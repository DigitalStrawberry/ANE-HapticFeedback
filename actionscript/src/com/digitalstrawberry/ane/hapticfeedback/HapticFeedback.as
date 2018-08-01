/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2017 Digital Strawberry LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package com.digitalstrawberry.ane.hapticfeedback
{
	
	CONFIG::ane
	{
		import flash.external.ExtensionContext;
	}

	import flash.system.Capabilities;

	/**
	 * Haptic feedback extension's API.
	 */
	public class HapticFeedback
	{
		/**
		 * Extension version.
		 */
		public static const VERSION:String = "1.1.0";

		private static const EXTENSION_ID:String = "com.digitalstrawberry.ane.hapticfeedback";
		private static const iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") > -1;
		
		CONFIG::ane
		{
			private static var mContext:ExtensionContext;
		}
		
		/* Generator id counter */
		private static var mGeneratorId:int;
		
		
		/**
		 * @private
		 * Do not use. HapticFeedback is a static class.
		 */
		public function HapticFeedback()
		{
			throw Error("HapticFeedback is static class.");
		}
		
		
		/**
		 *
		 *
		 * Public API
		 *
		 *
		 */
		
		public static function getImpactGenerator(impactFeedbackStyle:int):ImpactFeedbackGenerator
		{
			if (!ImpactFeedbackStyle.isValid(impactFeedbackStyle))
			{
				throw new ArgumentError("Impact feedback style must be one of the values defined in ImpactFeedbackStyle class.");
			}

			FeedbackGenerator.CAN_INITIALIZE = true;
			var generator:ImpactFeedbackGenerator = new ImpactFeedbackGenerator(impactFeedbackStyle);
			generator.id = ++mGeneratorId;
			if (iOS && initExtensionContext())
			{
				CONFIG::ane
				{
					mContext.call("initImpactGenerator", generator.id, impactFeedbackStyle);
				}
			}
			return generator;
		}
		

		public static function getNotificationGenerator():NotificationFeedbackGenerator
		{
			FeedbackGenerator.CAN_INITIALIZE = true;
			var generator:NotificationFeedbackGenerator = new NotificationFeedbackGenerator();
			generator.id = ++mGeneratorId;
			if (iOS && initExtensionContext())
			{
				CONFIG::ane
				{
					mContext.call("initNotificationGenerator", generator.id);
				}
			}
			return generator;
		}
		

		public static function getSelectionGenerator():SelectionFeedbackGenerator
		{
			FeedbackGenerator.CAN_INITIALIZE = true;
			var generator:SelectionFeedbackGenerator = new SelectionFeedbackGenerator();
			generator.id = ++mGeneratorId;
			if (iOS && initExtensionContext())
			{
				CONFIG::ane
				{
					mContext.call("initSelectionGenerator", generator.id);
				}
			}
			return generator;
		}


		public static function setLogEnabled(value:Boolean):void
		{
			if (!iOS || !initExtensionContext())
			{
				return;
			}

			CONFIG::ane
			{
				mContext.call("setLogEnabled", value);
			}
		}


		public static function get isAvailable():Boolean
		{
			var result:Boolean;
			if (!iOS || !initExtensionContext())
			{
				return result;
			}

			CONFIG::ane
			{
				result = mContext.call("isAvailable") as Boolean;
			}
			return result;
		}
		
		
		/**
		 * Disposes native extension context.
		 */
		public static function dispose():void
		{
			if (!iOS)
			{
				return;
			}
			
			CONFIG::ane
			{
				if (mContext !== null)
				{
					mContext.dispose();
					mContext = null;
				}
			}
		}
		
		
		/**
		 *
		 *
		 * Internal API
		 *
		 *
		 */


		/**
		 * @private
		 */
		internal static function prepareGenerator(generator:FeedbackGenerator):void
		{
			if (!iOS || !initExtensionContext())
			{
				return;
			}
			CONFIG::ane
			{
				mContext.call("prepareGenerator", generator.id);
			}
		}


		/**
		 * @private
		 */
		internal static function releaseGenerator(generator:FeedbackGenerator):void
		{
			if (!iOS || !initExtensionContext())
			{
				return;
			}
			CONFIG::ane
			{
				mContext.call("releaseGenerator", generator.id);
			}
		}


		/**
		 * @private
		 */
		internal static function triggerImpact(generator:FeedbackGenerator):void
		{
			if (!iOS || !initExtensionContext())
			{
				return;
			}
			CONFIG::ane
			{
				mContext.call("triggerImpactFeedback", generator.id);
			}
		}


		/**
		 * @private
		 */
		internal static function triggerSelection(generator:FeedbackGenerator):void
		{
			if (!iOS || !initExtensionContext())
			{
				return;
			}
			CONFIG::ane
			{
				mContext.call("triggerSelectionFeedback", generator.id);
			}
		}


		/**
		 * @private
		 */
		internal static function triggerNotification(generator:FeedbackGenerator, notificationFeedbackType:int):void
		{
			if (!iOS || !initExtensionContext())
			{
				return;
			}
			CONFIG::ane
			{
				mContext.call("triggerNotificationFeedback", generator.id, notificationFeedbackType);
			}
		}


		/**
		 *
		 *
		 * Private API
		 *
		 *
		 */
		
		/**
		 * Initializes extension context.
		 * @return <code>true</code> if initialized successfully, <code>false</code> otherwise.
		 */
		private static function initExtensionContext():Boolean
		{
			CONFIG::ane
			{
				if (mContext === null)
				{
					mContext = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				}
				return mContext !== null;
			}
			return false;
		}
		
	}
}
