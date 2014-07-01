/*
Copyright (c) 2013 Up2Go International LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products 
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 *	Controller class for the Advanced Lookup VF Component
 */
public with sharing class AdvancedLookupCtrl {
	// API Name of the SObject referenced by the wrapped inputField
	public String objectType { get; private set; }	
	
	// Value of the wrapped input field
	public String searchFilter { get; private set; }
	
	
	/**
	 * Constructor
	 */
	public AdvancedLookupCtrl() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		this.objectType  = getObjectTypeForPrefix(params.get('lktp'));
		this.searchFilter = params.get('lksrch');
	}
	
	
	/**
	 * Returns the API name for a given SObject prefix
	 */
	private String getObjectTypeForPrefix(String prefix) {
		Id fakeId =	Id.valueOf(prefix + 'd0000000yrHB'); // arbitrary suffix, just to make it look like an ID
		return fakeId.getSObjectType().getDescribe().getName();
	}
}