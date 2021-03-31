import getGiftBatchTotalsBy from '@salesforce/apex/GE_GiftEntryController.getGiftBatchTotalsBy';

const BatchTotals = async (batchId) => {
    const totals = await getGiftBatchTotalsBy({ batchId: batchId });
    const { PROCESSED, FAILED, FAILED_PAYMENT, EXPIRED_PAYMENT, TOTAL } = totals;

    return ({
        get processedGiftsCount() {
            return PROCESSED;
        },
        get failedGiftsCount() {
            return FAILED;
        },
        get failedPaymentsCount() {
            return FAILED_PAYMENT;
        },
        get expiredPaymentsCount() {
            return EXPIRED_PAYMENT;
        },                
        get totalGiftsCount() {
            return TOTAL;
        },
        get hasValuesGreaterThanZero() {
            return Number(PROCESSED) > 0 || Number(FAILED) > 0;
        },
    });
}

export default BatchTotals;