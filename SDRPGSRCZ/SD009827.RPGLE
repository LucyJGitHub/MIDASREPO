     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Close of Business System Value Reset')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009827 - Close of Business System Value Reset              *
      *                                                               *
      *  Function:  This program will save account balance check      *
      *             system values to Retail Account Balance Check     *
      *             ICD File                                          *
      *                                                               *
      *  Called By: SDC009827 - Close of Business System Value Reset  *
      *                         Control                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP205    *CREATE  Date 11Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP205 - Retail Account Balance Check                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
      * SrSysValues - Get System values                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Account Balance Check ICD File
 
     FSDABCIPD  O    E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Initialize fields to default settings on SDSVALPD
 
     D FieldsDS        DS
     D ABFTDR                              INZ(2)
     D ABFTCR                              INZ(2)
     D ABJEDR                              INZ(2)
     D ABJECR                              INZ(2)
     D ABTVDR                              INZ(2)
     D ABTVCR                              INZ(2)
     D ABAFDR                              INZ(2)
     D ABAFCR                              INZ(2)
     D ABSEDR                              INZ(2)
     D ABSECR                              INZ(2)
     D ABTSDR                              INZ(2)
     D ABTSCR                              INZ(2)
     D ABTFDR                              INZ(2)
     D ABTFCR                              INZ(2)
     D ABNDYF                              INZ(3)
     D FieldsArr                           LIKE(ABFTDR) DIM(15)
     D                                     OVERLAY(FieldsDS)
 
      ** AOSVALR0 parameters
 
     D PSysVal         S             20    DIM(10)
     D PCurSet         S            200    DIM(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D P@RTCD          S              7
     D P@OPTN          S              7
     D WRun            S              1N
 
      ** Array Indices
 
     D X               S              3P 0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Set up calling parameters for AOSVALR0
 
     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet
 
     C                   EVAL      PSysVal(1)  = 'ABCFTPaymentsDR'
     C                   EVAL      PSysVal(2)  = 'ABCFTPaymentsCR'
     C                   EVAL      PSysVal(3)  = 'ABCJournalEntryDR'
     C                   EVAL      PSysVal(4)  = 'ABCJournalEntryCR'
     C                   EVAL      PSysVal(5)  = 'ABCTransValueDR'
     C                   EVAL      PSysVal(6)  = 'ABCTransValueCR'
     C                   EVAL      PSysVal(7)  = 'ABCTransForwardDR'
     C                   EVAL      PSysVal(8)  = 'ABCTransForwardCR'
     C                   EVAL      PSysVal(9)  = 'ABCSEEventsDR'
     C                   EVAL      PSysVal(10) = 'ABCSEEventsCR'
 
     C                   EXSR      SrSysValues
 
      ** Populate Fields array elements 1 to 10
 
     C                   FOR       X = 1 TO 10
     C                   IF        PCurSet(X) <> *BLANKS
     C                   EVAL      FieldsArr(X) = %INT(%TRIM(PCurSet(X)))
     C                   ENDIF
     C                   ENDFOR
 
      ** Set up calling parameters for AOSVALR0
 
     C                   CLEAR                   PSysVal
     C                   CLEAR                   PCurSet
 
     C                   EVAL      PSysVal(1)  = 'ABCAcctfrsameDR'
     C                   EVAL      PSysVal(2)  = 'ABCAcctfrsameCR'
     C                   EVAL      PSysVal(3)  = 'ABCAcctfrfrwdDR'
     C                   EVAL      PSysVal(4)  = 'ABCAcctfrfrwdCR'
     C                   EVAL      PSysVal(5)  = 'ABCNoDaysForward'
 
      ** Get System Values
 
     C                   ExSr      SrSysValues
 
      ** Populate Fields array elements 11 to 15
 
     C                   FOR       X = 1 TO 5
     C                   IF        PCurSet(X) <> *BLANKS
     C                   EVAL      FieldsArr(X+10) = %INT(%TRIM(PCurSet(X)))
     C                   ENDIF
     C                   ENDFOR
 
     C                   EVAL      ABMODU = 'RETL'
     C                   WRITE     SDABCID0
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SrSysValues -  Get System Values                              *
      *                                                               *
      *****************************************************************
 
     C     SrSysValues   BEGSR
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM                    PSysVal(1)
     C                   PARM                    PCurSet(1)
     C                   PARM                    PSysVal(2)
     C                   PARM                    PCurSet(2)
     C                   PARM                    PSysVal(3)
     C                   PARM                    PCurSet(3)
     C                   PARM                    PSysVal(4)
     C                   PARM                    PCurSet(4)
     C                   PARM                    PSysVal(5)
     C                   PARM                    PCurSet(5)
     C                   PARM                    PSysVal(6)
     C                   PARM                    PCurSet(6)
     C                   PARM                    PSysVal(7)
     C                   PARM                    PCurSet(7)
     C                   PARM                    PSysVal(8)
     C                   PARM                    PCurSet(8)
     C                   PARM                    PSysVal(9)
     C                   PARM                    PCurSet(9)
     C                   PARM                    PSysVal(10)
     C                   PARM                    PCurSet(10)
 
      ** Check if database error occured
 
     C                   FOR       X = 1 TO 10
 
     C                   IF        PCurSet(X) = '*NRF'
     C                                      OR
     C                             P@RTCD <> *BLANKS
     C                               AND P@RTCD <> '*NRF'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY   = PSysVal(X)
     C                   EVAL      DBFILE  = 'SDSVALPD'
     C                   EVAL      DBASE   = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  *BLANKS
     C                   EVAL      DBKEY  =  *BLANKS
     C                   EVAL      DBPGM  =  'SD009827'
     C                   EVAL      DBASE  =  0
     C                   EVAL      DBMOD  =  *BLANKS
     C                   OUT       LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *OFF
     C                   EVAL      WRun = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
