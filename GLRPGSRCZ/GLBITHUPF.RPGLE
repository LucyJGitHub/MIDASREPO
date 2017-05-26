     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Header DB Update (Time-Out Processing)')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITHUPF - Journal Batch Entry Header Database Update       *
      *              (Time-Out Processing)                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD045854           Date 25May17               *
      *  Prev Amend No. AR1092517          Date 14Mar13               *
      *                 AR1003955          Date 13Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 249585             Date 16May12               *
      *                 263436             Date 20Jan10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC024             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 09Feb03               *
      *                 212722             Date 09Jan03               *
      *                 212141             Date 18Nov02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185628             Date 23Nov00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD045854 - Batch Detail cannot be entered with message       *
      *             Batch Header already accepted. Removed CAP209     *
      *             conditioning from AR1092517 fix.                  *
      *  AR1092517 - Transaction is not populated in List View for    *
      *              transactions with blank batch number             *
      *  AR1003955 - Background job DBU_BITH is dumping due to        *
      *              incorrect declaration of AOSARDR0 parameter      *
      *  CSC054 - Period End Adjustments                              *
      *  249585 - Journal Batch Entry through API. Partly apply 242986*
      *           Applied for AR971392 (Child: AR971393)              *
      *  263436 - GL batch was not accepted thru API for multi-branch *
      *           and multi-currency batch items. Apply core fix      *
      *           249720 and apply part of 260539.                    *
      *  249720 - API Batch processing does not accept batch.         *
      *           The JE API checks for DR/CR balance for currency    *
      *           within each branch instead of checking the batch    *
      *           currency total.                                     *
      *  260539 -  Remove 'TIME OUT' text in batch description.       *
      *  CSC024 - Open Month End (Recompile)                          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Do not process batches entered through MidasPlus    *
      *  212722 - When interval wait time is reached, do not reset    *
      *           in use flag in order to avoid a db error in DBU_BITP*
      *  212141 - Add a delay to wait for item files to be updated.   *
      *  185628 - Lock Problem with Database Updater DBU_BITH.        *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** JE Headers file - update
     F*****GLJENHL0  UF   E           K DISK    INFSR(*PSSR)                    185628
     FGLJENHL4  UF   E           K DISK    INFSR(*PSSR)                         185628
     F                                     RENAME(@BRREMA:@BRREMA4)             185628
     F                                     COMMIT
      *
      ** JE Headers and Items by Batch No. and Timestamp
     FGLJEHIL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LT:2)
      *
      ** JE Summary file
     FGLJENSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for SAR details                                              CSC054
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC054
                                                                                              CSC054
      ** DS for access programs - short data structure                                        CSC054
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC054
                                                                                              CSC054
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WCompTmSt       S             26Z
     D WSysTmSt        S             26Z
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     I@BRREMA                                                                                 CGL029
     I              QQACCF                      QQACC1                                        CGL029
     I              QQACCT                      QQACC2                                        CGL029
     I@BTREMG                                                                                 CGL029
     I              QQACCD                      QQACC3                                        CGL029
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   MOVE      *BLANKS       WHIIN            15
     C                   MOVE      *BLANKS       WHDIN             3
     C                   MOVE      'Y'           WCcyBal           1
      *
     C******LOVAL        SETLL     GLJENHL0                                     185628
     C*****              READ      GLJENHL0                               01    185628
     C     *LOVAL        SETLL     GLJENHL4                                     185628
     C                   READ      GLJENHL4                               01    185628
      *
     C     *IN01         DOWEQ     *OFF
      *
      ***Process only records with Batch in Use = 'Y', Front Office Id <>       185628
      ***blanks, Batch Status = 'H' and Workstation Id = blanks.                185628
      *****                                                                     185628
     C*****BRBIUF        IFEQ      'Y'                                          185628
     C*****BRFRNT        ANDNE     *BLANKS                                      185628
     C*****BRBTSF        ANDEQ     'H'                                          185628
     C*****BRWSID        ANDEQ     *BLANKS                                      185628
      * Do not update batch items that have been input through MidasPlus        CAP084
      ** Front office only updated from 3rd party                                             CSC054
     C                   MOVEL     BRFRNT        BRFRNT9           9            CAP084
     C     BRFRNT9       IFNE      'APCTRANVU'                                  CAP084
     C*****CGL125        ANDEQ     'N'                                             CSC054  AR1092517
     C*****CGL125        OREQ      'Y'                                             CSC054  AR1092517
     C*****CAP209        ANDEQ     'N'                                            AR1092517 MD045854
     C*****CAP209        OREQ      'Y'                                            AR1092517 MD045854
     C     BRFRNT        ANDNE     *BLANKS                                                    CSC054
     C                   EXSR      SRProces
     C                   ENDIF                                                  CAP084
     C*****              ENDIF                                                  185628
      *
     C*****              READ      GLJENHL0                               01    185628
     C                   READ      GLJENHL4                               01    185628
     C                   ENDDO
      *
      ** Exit program.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProces - Process Transaction                               *
      *                                                               *
      *****************************************************************
      *
     C     SRProces      BEGSR
      *
     C                   SELECT
      *
      ** If no. of items input is equal to no. of items calculated,
      ** and department code is not blank, then all entries for the
      ** batch have already been received; do final processing for
      ** the batch.
      *
     C     BRHINI        WHENEQ    BRHINC
     C     BRDPCD        ANDNE     *BLANKS
      *
      ** Set up hash totals and other fields.
      *
     C                   EXSR      SRHash
      *
      ** If batch is valid and hash totals input is equal to
      ** hash totals calculated, check currency totals in
      ** GLJENSPD.
      *
     C     BRVALI        IFEQ      'Y'
     C     BRHIIN        ANDEQ     BRHICC
     C     BRHDIN        ANDEQ     BRHDCC
     C                   EXSR      SRChkCcy
     C                   ENDIF
      *
      ** If no. of items input is greater than the no. of items
      ** calculated, or department code is blank, then all
      ** entries for the batch have not yet arrived; check
      ** if system still has to wait for the other entries
      ** to arrive.
      *
     C     BRHINI        WHENGT    BRHINC
     C     BRDPCD        OREQ      *BLANKS
     C                   EXSR      SRPrNtRcv
      *
      ** If no. of items input is less than the no. of items
      ** calculated, do final processing for the batch.
      *
     C                   OTHER
     C                   EXSR      SRHash
      *
     C                   ENDSL
      *
      ** Update batch header record.
      *
     C*****              UPDATE    @BRREAG                                      185628
     C                   UPDATE    @BRREMA4                                     185628
     C                   COMMIT
      *
      ** If batch status is accepted, submit batch for shadow
      ** posting.
      *
     C     BRBTSF        IFEQ      'A'
     C                   CALL      'GLSBMBCH'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM      BRBTNB        PBTNB             3
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHash - Set up Hash Totals and other fields                 *
      *                                                               *
      *****************************************************************
      *
     C     SRHash        BEGSR
      *
      ** If hash totals input (integer and decimal) is equal to
      ** 999,999,999,999,999.999, then update hash totals input
      ** with hash totals calculated.
      *
     C                   MOVE      BRHIIN        WHIIN
     C                   MOVE      BRHDIN        WHDIN
      *
     C     WHIIN         IFEQ      *ALL'9'
     C     WHDIN         ANDEQ     *ALL'9'
     C                   Z-ADD     BRHICC        BRHIIN
     C                   Z-ADD     BRHDCC        BRHDIN
     C                   ENDIF
      *
      ** Set Batch in Use flag to blank.
      *
     C                   MOVE      *BLANK        BRBIUF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkCcy - Check Currency Totals                             *
      *                                                               *
      *****************************************************************
      *
     C     SRChkCcy      BEGSR
      *
      ** Position currency file in batch number.
      *
     C                   MOVEL     *BLANKS       KCYCD             3                          249720
     C                   MOVEL     *BLANKS       KBRCD             3                          249720
      *                                                                                       249720
     C     KEY001        KLIST                                                                249720
     C                   KFLD                    BRBTNB                                       249720
     C                   KFLD                    KCYCD                                        249720
     C                   KFLD                    KBRCD                                        249720
      *                                                                                       249720
     C*****BRBTNB        SETLL     GLJENSL1                                                   249720
     C     KEY001        SETLL     GLJENSL1                                                   249720
     C     BRBTNB        READE     GLJENSL1                               01
      *
      *                                                                                    212141
      ** If record not found, issue a delay of 10 sec. then                                212141
      ** try to retrieve the record again.                                                 212141
      *                                                                                    212141
     C     *IN01         IFEQ      *ON                                                     212141
     C                   CALLB     'ZACDELAY'                                              212141
     C     BRBTNB        SETLL     GLJENSL1                                                212141
     C     BRBTNB        READE     GLJENSL1                               01               212141
      *                                                                                    212141
     C     *IN01         IFEQ      *ON
     C                   MOVE      'N'           WCcyBal
     C                   ENDIF
      *                                                                                    212141
     C                   ENDIF                                                             212141
      *                                                                                       249720
      ** Initialize work variable                                                             249720
      *                                                                                       249720
     C                   MOVEL     *BLANKS       XCYCD             3                          249720
     C                   Z-ADD     0             XCRTT            15 0                        249720
     C                   Z-ADD     0             XdbTT            15 0                        249720
      *
      ** Check if currency DR and CR totals balance.
      *
     C     *IN01         DOWEQ     *OFF
     C     WCcyBal       ANDEQ     'Y'
      *
     C*****BSDBTT        IFNE      BSCRTT                                                     249720
     C**********         MOVE      'N'           WCcyBal                                      249720
     C**********         ENDIF                                                                249720
      *
      ** Accumulate debit and credit totals for the same currency                             249720
      *                                                                                       249720
     C     XCYCD         IFEQ      BSCYCD                                                     249720
     C                   ADD       BSCRTT        XCRTT                                        249720
     C                   ADD       BSDBTT        XDBTT                                        249720
     C                   ELSE                                                                 249720
      *                                                                                       249720
      ** At the change of currency,                                                           249720
      ** compare the debit and credit total of the previous currency                          249720
      *                                                                                       249720
     C     XCRTT         IFNE      XDBTT                                                      249720
     C                   MOVEL     'N'           WCcyBal                                      249720
     C                   ELSE                                                                 249720
     C                   Z-ADD     BSCRTT        XCRTT                                        249720
     C                   Z-ADD     BSDBTT        XDBTT                                        249720
     C                   MOVEL     BSCYCD        XCYCD                                        249720
     C                   ENDIF                                                                249720
      *                                                                                       249720
     C                   ENDIF                                                                249720
      *                                                                                       249720
     C**********         READE     GLJENSL1                               01                  249720
     C     BRBTNB        READE     GLJENSL1                               01                  249720
     C                   ENDDO
      *                                                                                       249720
     C     XCRTT         IFNE      XDBTT                                                      249720
     C                   MOVEL     'N'           WCcyBal                                      249720
     C                   ENDIF                                                                249720
      *
      ** If currency totals balance and Batch Held/Accepted
      ** Indicator is 'A', check if Batch Status flag can
      ** be changed from 'H' to 'A'.
      *
     C     WCcyBal       IFEQ      'Y'
     C     BRBHAI        ANDEQ     'A'
      *
      ** Batch Status is set to 'A' only if Multiple Branch
      ** Batch is 'Y' or Branch Code is equal to Input Branch
      ** Code.
      *
     C     BRMBRB        IFEQ      'Y'
     C     BRBCDA        OREQ      BRIBCF
      *
     C                   MOVE      'A'           BRBTSF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrNtRcv - Routine to check if system still has to wait     *
      *              for the other entries to arrive                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPrNtRcv     BEGSR
      *
      ** Check Timestamp of last entry for the batch.
      *
     C     BRBTNB        SETGT     GLJEHIL1
     C     BRBTNB        READPE    GLJEHIL1                               01
      *
     C     *IN01         IFEQ      *OFF
      *
      ** Get Timestamp of last entry for the batch.
      *
     C                   MOVE      LTTMST        WCompTmSt
      *
      ** Add the Batch Interval in Seconds value on API ICD
      ** to the Timestamp of the last entry for the batch.
      *
     C                   ADDDUR    GHBINT:*S     WCompTmSt
      *
      ** Get current Timestamp.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WSysTmSt
      *
      ** If computed timestamp (last batch entry Timestamp plus
      ** Batch Interval in Seconds value on API ICD) is less
      ** than the current timestamp, do final processing for
      ** the batch.
      *
     C     WCompTmSt     IFLT      WSysTmSt
      *
      * Save batch in use flag                                                                212722
     C**********         MOVE      BRBIUF        WBRBIUF           1                   212722 249585
     C                   EXSR      SRHash
      *
      ***Move*'TIME*OUT'*from*position*23*of*Batch*Description.********                       260539
      **********                                                                              260539
     C**********         MOVEL     'TIME OUT'    BRBDES                                       260539
      *
      ** Restore batch in use flag to avoid DUMP and hold batch                               212722
      *                                                                                       212722
     C**********         MOVE      WBRBIUF       BRBIUF                                212722 249585
     C**********         MOVE      'H'           BRBHAI                                212722 263436
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Issue database error if there was no record read for
      ** this batch.
      *
     C                   MOVEL(P)  BRBTNB        DBKEY
     C                   MOVEL(P)  'GLJEHIL1'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** STANDING DATA
      ** =============
      *
      ** SDAPI - Batch Items Interval in Seconds
     C                   PARM                    GHBINT            5 0
      *                                                                                       CSC054
      ** Access SAR details file to see if CGL125 is installed.                               CSC054
      *                                                                                       CSC054
     C                   CALLB     'AOSARDR0'                                                 CSC054
     C                   PARM      *BLANKS       PRTCD                                        CSC054
     C**********         PARM      '*VERIFY'     POPTN             3                CSC054 AR1003955
     C                   PARM      '*VERIFY'     POPTN             7                       AR1003955
     C                   PARM      'CGL125'      PSARD             6                          CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC054
      *                                                                                       CSC054
     C                   IF        PRTCD <> *BLANKS AND                                       CSC054
     C                             PRTCD <> '*NRF'                                            CSC054
     C     *LOCK         IN        LDA                                                        CSC054
     C                   EVAL      DBPGM = 'GLBITHUPD'                                        CSC054
     C                   EVAL      DBKEY = 'CGL125'                                           CSC054
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSC054
     C                   EVAL      DBASE  = 02                                                CSC054
     C                   OUT       LDA                                                        CSC054
     C                   EXSR      *PSSR                                                      CSC054
     C                   ENDIF                                                                CSC054
      *                                                                                       CSC054
     C     PRTCD         IFEQ      *BLANK                                                     CSC054
     C                   MOVE      'Y'           CGL125            1                          CSC054
     C                   ELSE                                                                 CSC054
     C                   MOVE      'N'           CGL125                                       CSC054
     C                   ENDIF                                                                CSC054
      *****************************************************************              CSC054 MD045854
      ***Access*SAR*details*file*to*see*if*CAP209*is*installed.********           AR1092517 MD045854
      *****************************************************************           AR1092517 MD045854
     C**********         MOVE      'N'           CAP209            1              AR1092517 MD045854
     C**********         CALL      'AOSARDR0'                                     AR1092517 MD045854
     C**********         PARM      *BLANKS       PRTCD                            AR1092517 MD045854
     C**********         PARM      '*VERIFY'     POPTN                            AR1092517 MD045854
     C**********         PARM      'CAP209'      PSARD                            AR1092517 MD045854
     C*****SCSARD        PARM      SCSARD        DSFDY                            AR1092517 MD045854
      *                                                                           AR1092517 MD045854
     C**********         IF        PRTCD <> *BLANKS AND                           AR1092517 MD045854
     C**********                   PRTCD <> '*NRF'                                AR1092517 MD045854
     C******LOCK         IN        LDA                                            AR1092517 MD045854
     C**********         EVAL      DBPGM = 'GLBITHVU'                             AR1092517 MD045854
     C**********         EVAL      DBKEY = 'CAP209'                               AR1092517 MD045854
     C**********         EVAL      DBFILE ='SCSARDPD'                             AR1092517 MD045854
     C**********         EVAL      DBASE  = 5                                     AR1092517 MD045854
     C**********         OUT       LDA                                            AR1092517 MD045854
     C**********         EXSR      *PSSR                                          AR1092517 MD045854
     C**********         ENDIF                                                    AR1092517 MD045854
      *                                                                           AR1092517 MD045854
     C**********         IF        PRTCD = *BLANKS                                AR1092517 MD045854
     C**********         EVAL      CAP209 = 'Y'                                   AR1092517 MD045854
     C**********         ENDIF                                                    AR1092517 MD045854
      **********                                                                  AR1092517 MD045854
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
