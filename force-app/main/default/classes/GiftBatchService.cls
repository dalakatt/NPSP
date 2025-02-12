/*
    Copyright (c) 2021 Salesforce.org
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce.org
* @date 2021
* @description Service class for Gift Batches in NPSP.
*/
public with sharing class GiftBatchService {

    public static final List<String> PAYMENT_INTEGRATION_FIELDS = new List<String>{
        String.valueOf(DataImport__c.Donation_Amount__c), 
        String.valueOf(DataImport__c.Donation_Date__c), 
        String.valueOf(DataImport__c.Contact1Imported__c),
        String.valueOf(DataImport__c.Contact1_Firstname__c), 
        String.valueOf(DataImport__c.Contact1_Lastname__c), 
        String.valueOf(DataImport__c.Account1Imported__c),
        String.valueOf(DataImport__c.Account1_Name__c)
    };

    public Map<String, Integer> getGiftBatchTotalsMapFor(Id batchId) {
        GiftBatches batches = new GiftBatches(new Set<Id> {batchId}, new GiftBatchSelector());
        GiftBatchGroupedTotals groupedTotals = batches.getGroupedTotals();
        return groupedTotals.totalsFor(batchId);
    }

    public void processGiftsFor(Id batchId) {
        GiftBatch giftBatch = new GiftBatch(new GiftBatchId(batchId));
        giftBatch.processGifts();
    }

    public void giftsFailedCaptureFor(Id batchId, Map<String, String> failReasonByElevateBatchId) {
        GiftBatch giftBatch = new GiftBatch(new GiftBatchId(batchId));
        giftBatch.failGiftsWithReason(failReasonByElevateBatchId);
        giftBatch.updateRecords();
    }

    public GiftBatchView viewModelFrom(GiftBatchId giftBatchId) {
        GiftBatch giftBatch = new GiftBatch(giftBatchId);
        GiftBatchDTO giftBatchDTO = new GiftBatchDTO(giftBatch);
        return new GiftBatchView(giftBatchDTO);
    }

    public GiftBatchView viewModelWithLimitsAndOffsets(
        GiftBatchId giftBatchId, Integer giftsLimit, Integer giftsOffset) {
            GiftBatch giftBatch = new GiftBatch(giftBatchId, giftsLimit, giftsOffset);
            GiftBatchDTO giftBatchDTO = new GiftBatchDTO(giftBatch);
            return new GiftBatchView(giftBatchDTO);
    }

    public GiftBatchView store(InboundGiftBatchDTO giftBatchChanges) {
        GiftBatchId giftBatchId = new GiftBatchId(giftBatchChanges.giftBatchId);
        GiftBatch giftBatch = new GiftBatch(giftBatchId);
        giftBatch.updateWith(giftBatchChanges);
        return viewModelFrom(giftBatchId);
    }

    public GiftBatchView deleteMemberGiftBy(GiftBatchId giftBatchId, GiftId giftId) {
        GiftBatch giftBatch = new GiftBatch(giftBatchId);
        giftBatch.deleteGiftBy(giftId);
        return viewModelFrom(giftBatchId);
    }

    public void add(GiftBatchId giftBatchId, InboundGiftDTO inboundGift) {
        GiftBatch giftBatch = new GiftBatch(giftBatchId);
        giftBatch.add(inboundGift.asGift());
    }
}
