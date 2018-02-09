     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Accounts Posting')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE005005 - Accounts Posting                                  *
      *                                                               *
      *  Called By: REC005005 - Midas RE Accounts Posting             *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD037756           Date 26Apr16               *
      *                 CGL165             Date 17Feb15               *
      *                 CRE083BM           Date 06Aug12               *
      *                 AR848501           Date 10Nov11               *
      *                 CER055  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD037756 - Component went on MSGW due to missing member but  *
      *             did not fail. Fix is to perform *PSSR in case of  *
      *             error.                                            *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CRE083BM - COB Restructure - RE COB Optimisation Phase 1     *
      *  AR848501 - The data in the field "Number of Days in Excess"  *
      *             is not correct                                    *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         General Indicator Used For CHAIN                *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR      - Initialise                                      *
      * *PSSR       - Error processing                                *
      *                                                               *
      *****************************************************************
     F***ACCNTAB   IF   E           K DISK                                                  CRE083BM
     F***GLRACCL1  IF   E           K DISK                                         CRE083BM MD037756
     FGLRACCL1  IF   E           K DISK    INFSR(*PSSR)                                     MD037756
     F                                     USROPN                                           MD037756
      ** Midas GL Account Master Details File
 
     F***ACCNTBY0  UF   E           K DISK                                                  MD037756
     FACCNTBY0  UF   E           K DISK    INFSR(*PSSR)                                     MD037756
     F                                     USROPN                                           MD037756
      ** Midas GL Account Details Extension File
 
     F***REAOHSPD  IF A E           K DISK                                                  MD037756
     FREAOHSPD  IF A E           K DISK    INFSR(*PSSR)                                     MD037756
     F                                     USROPN                                           MD037756
      ** Midas RE Accounts Overdraft History File
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** External data structures for Switchabe features
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structures for Access Objects
 
     D JNSTAT        E DS                  EXTNAME(JNSTAT)
      ** Data Area giving Installation Control Details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D***CER055*         S              1A                                                  CRE083BM
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Start of processing
 
     C**********         IF        CER055 = 'Y'                                             CRE083BM
 
     C                   EXSR      SRProcODP
 
     C**********         ENDIF                                                              CRE083BM
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcODP  - Process Update of Overdraft Information in      *
      *               Accounts file                                   *
      *                                                               *
      *****************************************************************
     C     SRProcODP     BEGSR
 
     C**********         READ      ACCNTABF                                                 CRE083BM
     C**********         DOW       NOT %EOF(ACCNTAB)                                        CRE083BM
     C                   READ      GLRACCL1                                                 CRE083BM
     C                   DOW       NOT %EOF( GLRACCL1 )                                     CRE083BM
 
      ** Process if account is a Retail Account
 
     C**********         IF        ATYP = 'R' AND                                           CRE083BM
     C**********                   RECI <> 'C'                                              CRE083BM
 
     C     KACCNT        CHAIN     ACCNTBY0
     C                   IF        %FOUND(ACCNTBY0)
 
      ** Update Overdraft fields if:
      ** Debit Balance is greater than Overdraft Limit (not expired)
      ** Overdraft limit is equal to zero
      ** Overdraft Limit date is expired
 
     C                   IF        CLBL >= 0
 
     C                   IF        (CLBL > ODLN AND
     C                             ODED > BJRDNB) OR
     C                             ODLN = 0 OR
     C                             ODED <= BJRDNB
 
     C                   EVAL      ATDOBE = BJRDNB
     C**********         EVAL      ATNDYE = ATNDYE + (BJRDNB - PRUN)                        AR848501
     C**********         EVAL      ATNDYO = ATNDYO + (BJRDNB - PRUN)                        AR848501
     C                   EVAL      ATNDYE = ATNDYE + (BJDNWD - BJRDNB)                      AR848501
     C                   EVAL      ATNDYO = ATNDYO + (BJDNWD - BJRDNB)                      AR848501
 
     C                   ENDIF
     C                   ENDIF
 
      ** Reset the overdraft fields if:
      ** Debit balance is less than Overdraft limit (not expired)
      ** and the Date of Overdraft Balance in excess is non-zero
      ** Credit balance and Date of Overdraft Balance in excess is non-zero
 
     C                   IF        ((CLBL >= 0 AND
     C                             CLBL < ODLN AND
     C                             ODED > BJRDNB) OR
     C                             CLBL < 0) AND
     C                             ATDOBE <> 0
 
     C                   EVAL      ATDOBE = 0
     C                   EVAL      ATNDYE = 0
     C                   ENDIF
 
      ** Update Overdraft fields in Accounts Master file
      ** Write records in Overdraft History file
 
     C                   UPDATE    ACCNTBD0
 
      ** Update Overdraft History File fields
 
     C                   EVAL      PODL = ATPOLA
     C                   EVAL      PODE = ATPOLE
     C                   EVAL      DOBE = ATDOBE
     C                   EVAL      NYDE = ATNDYE
     C                   EVAL      NYDO = ATNDYO
     C                   EVAL      HISD = BJRDNB
 
     C                   WRITE     REAOHSD0
 
     C                   ENDIF
 
     C**********         ENDIF                                                              CRE083BM
 
     C**********         READ      ACCNTABF                                                 CRE083BM
     C                   READ      GLRACCL1                                                 CRE083BM
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialise LDA field
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'RE005005'    DBPGM
     C                   OUT       LDA
     C
     C     *DTAARA       DEFINE                  JNSTAT
     C                   IN        JNSTAT
     C
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ***Check*if*CER055*is*installed**********************************                     CRE083BM
 
     C**********         EVAL      CER055 = 'N'                                             CRE083BM
     C**********         CALL      'AOSARDR0'                                               CRE083BM
     C**********         PARM      *BLANKS       PRTCD                                      CRE083BM
     C**********         PARM      '*VERIFY'     POPTN                                      CRE083BM
     C**********         PARM      'CER055'      PSARD             7                        CRE083BM
     C*****SCSARD        PARM      SCSARD        DSFDY                                      CRE083BM
 
     C**********         IF        PRTCD = *BLANKS                                          CRE083BM
     C**********         EVAL      CER055 = 'Y'                                             CRE083BM
     C**********         ELSE                                                               CRE083BM
 
     C**********         IF        PRTCD <> '*NRF   '                                       CRE083BM
     C******LOCK         IN        LDA                                                      CRE083BM
     C**********         EVAL      DBFILE = 'SCSARDPD'                                      CRE083BM
     C**********         EVAL      DBKEY = PSARD                                            CRE083BM
     C**********         EVAL      DBASE = 2                                                CRE083BM
     C**********         OUT       LDA                                                      CRE083BM
     C**********         EXSR      *PSSR                                                    CRE083BM
     C**********         ENDIF                                                              CRE083BM
 
     C**********         ENDIF                                                              CRE083BM
 
     C     KACCNT        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
     C                   OPEN      GLRACCL1                                                 MD037756
     C                   OPEN      ACCNTBY0                                                 MD037756
     C                   OPEN      REAOHSPD                                                 MD037756
                                                                                            MD037756
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
