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

$j = jQuery.noConflict();
        
$j(document).ready(function() {
    blockNode = function(nodeId) {
		var node = $j('[id$="' + nodeId + '"]');
        node.block({ message: null });
    };
    
    unblockNode = function(nodeId) {
        var node= $j('[id$="' + nodeId + '"]');
        node.unblock();
    };
    
	collapseSections = function() {      
		$j('.hideListButton').each(function() {
			twistSection(this);
		});
	};
    
    pasteVertically = function(source, fieldName, fieldType) {
        var className = '.inputField_' + fieldName;
        var sourceElement = document.getElementById(source);
        var valueToCopy = $j(sourceElement).parent().find(className).val(); 
        
        var hiddenValuesToCopy;
        if(fieldType==='reference') {
            hiddenValuesToCopy = $j(source).siblings('input');
        }
        
        $j('.rowSelector:checked').each(function() {
            var fieldToPasteTo = $j(this).parents('.dataRow').find(className);
            fieldToPasteTo.val(valueToCopy);
            fieldToPasteTo.change();
            
            if(fieldType==='reference') {
                fieldToPasteTo.parents('.rowCell_' + fieldName).find('.pasteButton_' + fieldName).siblings('input').each( function(i, v) {
                    $j(v).val($j(hiddenValuesToCopy.get(i)).val());
                });
            }
        });
    };
    
    toggleAll = function(source) {
        var isChecked = $j(source).is(':checked');
        var checkboxes = $j(source).closest("[id$='table']").find('.rowSelector');
        
        checkboxes.each(function() {
            $j(this).attr('checked', isChecked); 
            
            var wasSelected = $j(this).parents('.dataRow').hasClass('isSelected');
            
            if(isChecked && !wasSelected) {
                $j(this).parents('.dataRow').addClass('isSelected');
            }
            else if(!isChecked && wasSelected) {
                $j(this).parents('.dataRow').removeClass('isSelected');
            }
        });
    };
	    
	resizeIFrames = function(node) {
	 	$j('iframe', parent.document).each(function() {
	 		parent.resizeIFrame($j(this));
	 	});
	};
});  			