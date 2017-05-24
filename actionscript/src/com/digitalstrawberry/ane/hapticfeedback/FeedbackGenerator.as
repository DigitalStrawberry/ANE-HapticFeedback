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

	/**
	 * The abstract superclass for all feedback generators.
	 */
	public class FeedbackGenerator
	{
		/**
		 * @private
		 */
		internal static var CAN_INITIALIZE:Boolean; // Makes sure only HapticFeedback can create new generators

		/**
		 * @private
		 */
		internal var id:uint;
		
		public function FeedbackGenerator()
		{
			if(!CAN_INITIALIZE)
			{
				throw new Error("Use HapticFeedback class to access feedback generators.");
			}
			CAN_INITIALIZE = false;
		}


		public function prepare():void
		{
			HapticFeedback.prepareGenerator(this);
		}


		public function release():void
		{
			HapticFeedback.releaseGenerator(this);
		}
		
	}
	
}
