     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward rates database update')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing ILE Module                                   *
      *                                                               *
      *  FDFWRTUPD - Forward Rates Database Update                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR746232           Date 03Aug11               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260291             Date 18May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255602             Date 23Jul08               *
      *                 255234             Date 02Jul08               *
      *                 241919             Date 22Dec06               *
      *                 BUG12772           Date 09Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240882             Date 04Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 236847             Date 03Feb06               *
      *                 BUG8233            Date 23Aug05               *
      *                 BUG8141            Date 11Aug05               *
      *                 237331             Date 20Feb06               *
      *                 BUG7025            Date 01Jun05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 19Oct00               *
      *                 CAP059             Date 19Oct00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR746232 - DLC0601D 00001. File Control Out of Balance.      *
      *             Apply AR692676 (Child: AR746233)                  *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  260291 - Spot rate updated even when FWRTSpotRateUpd is 'N'. *
      *           Add condition when updating spot rates.             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255602 - Serious Midas error occured in Forward Rates        *
      *           maintenance. OVRDBF file SDCURRL1 with SHARE(*NO)   *
      *           to avoid error in AOCURRC0.                         *
      *  255234 - DLC0601D component failed. Applied core fix 253283. *
      *  253283 - Added condition for Amendment(FWRAMD) to determine  *
      *           if inserted record is an amendment or a previously  *
      *           deleted record then reactivated.                    *
      *  241919 - Recompiled due to changes done to FDVFWRTPD.        *
      *  BUG12772 - Error in updating FWDRTFD file for insert         *
      *             transaction but amend was done in FWDRTFE file.   *
      *  240882 - Do not update Spot Rate with Forward Rate if        *
      *           system value FWRTSpotRateUpd = N                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  236847 - Zeroise empty forward points so that it will be     *
      *           displayed as blanks in the MidasPlus listview.      *
      *  BUG8233- Error in Forward Rates upload via File Adapter API  *
      *           (Recompile)                                         *
      *  BUG8141- Recompiled due to changes to FDVFWRTPD              *
      *  237331 - Zeroise empty forward points so that it will be     *
      *           displayed as blanks in the MidasPlus listview.      *
      *           Applied fix 236847.                                 *
      *  BUG7025 - Commitment Control error during authorisation of   *
      *            Spot Rates.  Problem occurs when the same          *
      *            connection job and commitment control is used for  *
      *            Forward rate and  Spot Rates maintenance.          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - MDF Changes.                                        *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
     FFWDRT     UF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFSR(*PSSR)                                       CSD006
     FSDMDFRL0  UF   E           K DISK    INFSR(*PSSR)                                       CSD006
     F                                     COMMIT                                            BUG7025
     FSDMDFIL0  UF   E           K DISK    INFSR(*PSSR)                                       CSD006
     F                                     COMMIT                                            BUG7025
     FSDMDFHPD  O    E           K DISK    INFSR(*PSSR)                                       CSD006
     F                                     COMMIT                                            BUG7025
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      * Constant to hold input parameter for AOSVALR0.                                        240882
     D PSysVal1        C                   Const('FWRTSpotRateUpd')                           240882
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAP059
     D                                     PREFIX(S_)                                         CAP059
      ** External DS for Switchable Features                                                  CAP059
                                                                                              CAP059
      **  Externally described data structure for valid forward rates record.
     D FDVFWR        E DS                  EXTNAME(FDVFWRTPD)
 
      **  Forward Rates file.
     D FWDRTS        E DS                  EXTNAME(FWDRTFE)
 
      **  Forward Rates file (Before Image)                                                   CAP059
     D B_FWDRTS      E DS                  EXTNAME(FWDRTFE)                                   CAP059
     D                                     PREFIX(B_)                                         CAP059
                                                                                              CAP059
      ** Forward Days - packed format.
     D WDSDAY          DS
     D  DAY                    1     75P 0
     D                                     DIM(25)
 
      ** Forward Rates - packed format.
     D WDSRAT          DS
     D  RAT                    1    175P 8
     D                                     DIM(25)
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CSD006
      ** External DS for General Ledger Details                                               CSD006
                                                                                              CSD006
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
      *                                                                                       CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
      *                                                                                       CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
      *                                                                                       CSC011
                                                                                              CSD006
      ** Time Stamp                                                                           CSD006
     D TimeStamp       S             26Z                                                      CSD006
 
      ** Override Database Table                                                              CAP059
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)                          CAP059
     D ##OX2           S              1    DIM(50) CTDATA PERRCD(50)                          255602
 
      ** 'IN' Currency Work Field                                                             CAP059
     D INCCY           S              1A                                                      CAP059
                                                                                              CSC011
      ** Defined fields for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimeStamp      S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D***PDealNum        S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PCurrency       S              3A                                                      CSC011
                                                                                              CAP059
     D PSysVal01       S             20A                                                      240882
     D PCurSet01       S            200A                                                      240882
     D PSysVal02       S             20A                                                      240882
     D PCurSet02       S            200A                                                      240882
     D PSysVal03       S             20A                                                      240882
     D PCurSet03       S            200A                                                      240882
     D PSysVal04       S             20A                                                      240882
     D PCurSet04       S            200A                                                      240882
     D PSysVal05       S             20A                                                      240882
     D PCurSet05       S            200A                                                      240882
     D PSysVal06       S             20A                                                      240882
     D PCurSet06       S            200A                                                      240882
     D PSysVal07       S             20A                                                      240882
     D PCurSet07       S            200A                                                      240882
     D PSysVal08       S             20A                                                      240882
     D PCurSet08       S            200A                                                      240882
     D PSysVal09       S             20A                                                      240882
     D PCurSet09       S            200A                                                      240882
     D PSysVal10       S             20A                                                      240882
     D PCurSet10       S            200A                                                      240882
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
     C                   Z-ADD     50            MESLEN           15 5                        CAP059
     C                   CALL      'QCMDEXC'                                                  CAP059
     C                   PARM                    ##OX1                                        CAP059
     C                   PARM                    MESLEN                                       CAP059
     C                   OPEN      FWDRT                                                      CAP059
                                                                                              CAP059
      *                                                                                       CAP059
      * Check to see if the record is to be deleted.                                          CAP059
      *                                                                                       CAP059
     C                   IF        FWCHTP = 'D'                                               CAP059
     C                   EXSR      SRDelete                                                   CAP059
     C                   ELSE                                                                 CAP059
      * Check for existing record.
      *
     C     FWCCY         CHAIN     FWDRTFEF                           99
      *
      * If not found insert new record.
      *
     C     *IN99         IFEQ      '1'
     C                   EXSR      FWRINS
     C                   ELSE
      *
      * Update existing Forward Rates record for currency.
      *
     C                   EXSR      FWRAMD
     C                   ENDIF
     C                   ENDIF                                                                CAP059
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'FDFWRTLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    FWDRTS                                       CSC011
     C                   PARM                    FWCHTP                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'FDFWRT'                                       CSC011
     C                   EVAL      APRPRLOCN  = FWREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   IF        CAP059 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   CALLB     'AOCURRR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*KEY   '     POPTN                                        CSC011
     C                   PARM      FWCCY         PCurrency                                    CSC011
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      APFOTRANID = A6FRNT                                        CSC011
     C                   EVAL      PDealNum = *Blanks                                         CSC011
     C                   ELSE                                                                 CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = FWCCY                                              CSC011
     C                   EVAL      DBFILE = 'SDCURRPD'                                        CSC011
     C                   EVAL      DBASE = 902                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
     C                   EVAL      APFOTRANID = FWFRNT                                        CSC011
     C                   MOVEL     FWCCY         PDealNum                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimestamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *                                                                                       CAP059
      * Recalculate forward rates if required                                                 CAP059
      *                                                                                       CAP059
     C                   IF        CEU026 = 'Y'                                               CAP059
     C                   EXSR      SRDL4130                                                   CAP059
     C                   ENDIF                                                                CAP059
      *
      * Exit from program.
      *
     C                   CLOSE     FWDRT                                                      CAP059
     C                   RETURN
     C****************************************************************
      /EJECT                                                                                  CSD006
      ****************************************************************                        CSD006
      *                                                              *                        CSD006
      * SRDL4130 - Recalculate forward rates                         *                        CSD006
      *                                                              *                        CSD006
      ****************************************************************                        CSD006
     C     SRDL4130      BEGSR                                                                CSD006
                                                                                              CSD006
      * Access currency data                                                                  CSD006
      * (Database error handling done in access program).                                     CSD006
                                                                                              CSD006
     C                   CALLB     'AOCURRR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD             7                          CSD006
     C                   PARM      '*KEY   '     @OPTN             7                          CSD006
     C                   PARM      BJCYCD        @KEYCY            3                          CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSD006
                                                                                              CSD006
      * If changed record = 'IN' currency or if the changed record equals                     CSD006
      * the EURO currency, recalculate the forward rates.                                     CSD006
                                                                                              CSD006
     C                   IF        A6INCY <> 'Y'                                              CSD006
     C                   MOVE      'N'           A6INCY                                       CSD006
     C                   ENDIF                                                                CSD006
 
     C                   IF        CEU026 = 'Y'                                               CSD006
      *                                                                                       CSD006
      * Check for whether the base currency is an 'IN' currency and                           CSD006
      * past its transition start date                                                        CSD006
      *                                                                                       CSD006
     C                   IF        A6INCY = 'Y' AND A6TPSD <= BJRDNB                          CSD006
     C                   EVAL      INCCY = 'Y'                                                CSD006
     C                   ELSE                                                                 CSD006
     C                   EVAL      INCCY = 'N'                                                CSD006
     C                   ENDIF                                                                CSD006
     C                   CALLB     'AOCURRR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD             7                          CSD006
     C                   PARM      '*KEY   '     @OPTN             7                          CSD006
     C                   PARM      FWCCY         @KEYCY            3                          CSD006
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSD006
                                                                                              CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
     C                   IF        A6INCY = 'Y'                                               CSD006
     C                             AND A6TPSD <= BJRDNB                                       CSD006
     C                                                                                        CSD006
     C                             OR FWCCY = BKEURO                                          CSD006
                                                                                              CSD006
     C                   CALL      'DL4130'                                                   CSD006
     C                   PARM                    BJCYCD                                       CSD006
     C                   PARM                    BKEURO                                       CSD006
     C                   PARM                    INCCY                                        CSD006
     C                   PARM      'N'           INITN             1                          CSD006
     C                   PARM      *BLANKS       RCODE             7                          CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
     C****************************************************************
      /EJECT                                                                                  CSD006
      ****************************************************************                        CSD006
      *                                                              *                        CSD006
      * SRDelete - Delete a record                                   *                        CSD006
      *                                                              *                        CSD006
      ****************************************************************                        CSD006
     C     SRDelete      BEGSR                                                                CSD006
                                                                                              CSD006
      ** Access Transaction Details                                                           CSD006
                                                                                              CSD006
     C     FWCCY         CHAIN     FWDRTFEF                           99                      CSD006
                                                                                              CSD006
      ** Update 'BEFORE' status                                                               CSD006
                                                                                              CSD006
     C                   IF        *IN99 = *OFF                                               CSD006
     C                   MOVEL(P)  FWDRTS        B_FWDRTS                                     CSD006
      *                                                                                       253283
      ** Last Change Type.                                                                    253283
      *                                                                                       253283
     C                   MOVE      'D'           CHTP                                         253283
                                                                                              CSD006
      ** Delete record                                                                        CSD006
                                                                                              CSD006
     C                   EVAL      RECI = '*'                                                 CSD006
     C                   UPDATE    FWDRTFEF                                                   CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
      * Update Trailer                                                                        CSD006
      *                                                                                       CSD006
     C     *LOVAL        SETLL     FWDRTFDF                                                   CSD006
     C                   READ      FWDRTFDF                               99                  CSD006
                                                                                              CSD006
     C     *IN99         IFEQ      *OFF                                                       CSD006
     C     NDEL          ADD       1             NDEL                                         CSD006
     C                   SUB       1             NLRA                                         CSD006
     C                   MOVE      BJRDNB        LCD                                          CSD006
     C                   UPDATE    FWDRTFDF                                                   CSD006
      *                                                                                       CSD006
      * Database error.                                                                       CSD006
      *                                                                                       CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     *BLANKS       DBKEY                                        CSD006
     C                   MOVEL     'FWDRTFD '    DBFILE                                       CSD006
     C                   MOVEL     '003'         DBASE                                        CSD006
     C                   EXSR      SRERR                                                      CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      ****************************************************************                        CSD006
      /EJECT
      ****************************************************************
      *                                                              *
      * FWRINS - Insert a new Forward Rates record.                  *
      *                                                              *
      ****************************************************************
     C     FWRINS        BEGSR
      *
      * Initialise Forward Rates record.
      *
     C                   CLEAR                   FWDRTS
      *
      * Record Id.
      *
     C                   MOVE      'D'           RECI
      *
      * Currency.
      *
     C                   MOVE      FWCCY         CCY
      *
      * Forward Days.
      *
     C                   MOVE      FWDFW         DFW
      *
      * Forward Rates.
      *
     C                   MOVE      FWRFW         RFW
      *
      * Last Change Date.
      *
     C                   MOVE      BJRDNB        LCD
      *
      * Last Change Type.
      *
     C                   MOVE      'I'           CHTP
      *
      * Transaction Number of Last Update.
      *
     C                   Z-ADD     0             TNLU
      *
      * Old Forward Points - REDUNDANT.
      *
     C                   MOVE      *BLANKS       PFW
      *
      * Forward Point Signs.
      *
     C                   IF        S01432 = 'Y'                                               CAP059
     C                   MOVE      FWSFW         SFW                                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      *BLANKS       SFW
     c                   ENDIF                                                                CAP059
      *
      * Forward Points.
      *
     C                   IF        S01432 = 'Y'                                               CAP059
     C                   MOVE      FWPNF         PNF                                          CAP059
     C                   ELSE                                                                 CAP059
     C**********         MOVE      *BLANKS       PNF                                          237331
     C                   MOVE      *ZEROS        PNF                                          237331
     C                   ENDIF                                                                CSD006
                                                                                              CAP059
      ** Generate Timestamp                                                                   CAP059
                                                                                              CAP059
     C                   CALLB     'ZAGENTMSTM'                                               CAP059
     C                   PARM                    TimeStamp                                    CAP059
      *                                                                                       CAP059
      * Setup MDF fields                                                                      CSD006
      *                                                                                       CSD006
     C     CAP059        IFEQ      'Y'                                                        CAP059
     C                   EXSR      SrSETMDF                                                   CAP059
     C                   ELSE                                                                 CAP059
                                                                                              CAP059
      ** Clear MDF fields                                                                     CAP059
                                                                                              CAP059
     C                   CLEAR                   FWTMESTMP                                    CAP059
     C                   EVAL      FWFRNT = *BLANK                                            CAP059
     C                   EVAL      FWAFRT = *BLANK                                            CAP059
     C                   EVAL      FWREPA = *BLANK                                            CAP059
     C                   EVAL      FWDFTS = *ZERO                                             CAP059
     C                   ENDIF                                                                CAP059
      *
      * Write new Forward Rates record.
      *
     C                   WRITE     FWDRTFEF
      *                                                                                       CSD006
      **Update*the*Spot*Rate*on*the*Currencies*files***                                       CSD006
      * Update the Spot Rate on the Currencies files if CSD006 is off                         CSD006
      *
     C                   IF        CSD006 = 'N' AND                                           CSD006
     C                             CAP029 = 'Y'                                               CSD006
      * Do not update spot rate is system value is 'N'                                        240882
     C                   IF        SPOTUPD <> 'N'                                             240882
     C                   EXSR      UPSPOT                                                     CSD006
     C                   ENDIF                                                                240882
     C                   ENDIF                                                                CSD006
      *
      * Update the Market Data Feeds files if the following statement                         CSD006
      * is true                                                                               CSD006
      *                                                                                       CSD006
     C                   IF        CSD006 = 'Y'                                               CSD006
     C                   IF        FWDTRF <> *BLANKS AND FWTLEX = 'Y'                         CSD006
     C                   EXSR      SDMDSR                                                     CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
      * Update the Market Data Feeds Rate/Price History file if the                           CSD006
      * following statement is true                                                           CSD006
      *                                                                                       CSD006
     C                   IF        FWDTRF <> *BLANKS                                          CSD006
     C                   EVAL      B_FWDRTS = *BLANKS                                         CSD006
     C                   EXSR      MDFHSR                                                     CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
      *
      * Update trailer.
      *
     C     *LOVAL        SETLL     FWDRTFDF
     C                   READ      FWDRTFDF                               99
      *
     C     *IN99         IFEQ      *OFF
     C     NINS          ADD       1             NINS
     C     NORE          ADD       1             NORE
     C     NLRA          ADD       1             NLRA
     C                   MOVE      BJRDNB        LCD
     C                   UPDATE    FWDRTFDF
      *
      * Database error.
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'FWDRTFD '    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* FWRAMD - Update existing Forward Rates record.               *
     C*                                                              *
     C****************************************************************
     C     FWRAMD        BEGSR
                                                                                              CAP059
      ** Save before image of the Forward Rates details                                       CAP059
                                                                                              CAP059
     C                   MOVEL     FWDRTS        B_FWDRTS                                     CAP059
     C     *LIKE         DEFINE    RECI          RECIX                                        253283
     C                   MOVE      RECI          RECIX                                        253283
      *
      * Record Id.
      *
     C                   MOVE      'D'           RECI
      *
      * Forward Days.
      *
     C                   MOVE      FWDFW         DFW
      *
      * Forward Rates.
      *
     C                   MOVE      FWRFW         RFW
      *
      * Last Change Date.
      *
     C                   MOVE      BJRDNB        LCD
      *
      * Last Change Type.
      *
     C                   MOVE      'A'           CHTP
      *
      * Transaction Number of Last Update.
      *
     C                   Z-ADD     0             TNLU
      *
      * Old Forward Points - REDUNDANT.
      *
     C                   MOVE      *BLANKS       PFW
      *
      * Forward Point Signs.
      *
     C                   IF        S01432 = 'Y'                                               CAP059
     C                   MOVE      FWSFW         SFW                                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVE      *BLANKS       SFW
     C                   ENDIF                                                                CAP059
      *
      * Forward Points.
      *
     C                   IF        S01432 = 'Y'                                               CAP059
     C                   MOVE      FWPNF         PNF                                          CAP059
     C                   ELSE                                                                 CAP059
     C**********         MOVE      *BLANKS       PNF                                          237331
     C                   MOVE      *ZEROS        PNF                                          237331
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
      ** Generate Timestamp                                                                   CAP059
                                                                                              CAP059
     C                   CALLB     'ZAGENTMSTM'                                               CAP059
     C                   PARM                    TimeStamp                                    CAP059
      *                                                                                       CSD006
      * Setup MDF fields                                                                      CSD006
      *                                                                                       CSD006
     C     CAP059        IFEQ      'Y'                                                        CAP059
     C                   EXSR      SrSETMDF                                                   CAP059
     C                   ELSE                                                                 CAP059
                                                                                              CAP059
      ** Clear MDF fields                                                                     CAP059
                                                                                              CAP059
     C                   CLEAR                   FWTMESTMP                                    CAP059
     C                   EVAL      FWFRNT = *BLANK                                            CAP059
     C                   EVAL      FWAFRT = *BLANK                                            CAP059
     C                   EVAL      FWREPA = *BLANK                                            CAP059
     C                   EVAL      FWDFTS = *ZERO                                             CAP059
     C                   ENDIF                                                                CAP059
      *
      * Update Forward Rates record
      *
     C                   UPDATE    FWDRTFEF
      *
      **Update*the*Spot*Rate*on*the*Currencies*files***                                       CAP059
      * Update the Spot Rate on the Currencies files if CAP059 is off                         CAP059
      *
     C                   IF        CSD006 = 'N'  AND                                          CSD006
     C                             CAP029 = 'Y'                                               CSD006
      *                                                                                       260291
      ** Do not update spot rate if system value is 'N'                                       260291
      *                                                                                       260291
     C                   IF        SPOTUPD <> 'N'                                             260291
     C                   EXSR      UPSPOT                                                     CSD006
     C                   ENDIF                                                                260291
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
      * Update the Market Data Feeds files if the following statement                         CSD006
      * is true                                                                               CSD006
      *                                                                                       CSD006
     C                   IF        FWDTRF <> *BLANKS AND FWTLEX = 'Y'                         CSD006
     C                   EXSR      SDMDSR                                                     CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
      * Update the Market Data Feeds Rate/Price History file if the                           CSD006
      * following statement is true                                                           CSD006
      *                                                                                       CSD006
     C                   IF        FWDTRF <> *BLANKS                                          CSD006
     C                   EXSR      MDFHSR                                                     CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
      * Update Trailer
      *
     C     *LOVAL        SETLL     FWDRTFDF
     C                   READ      FWDRTFDF                               99
      *
     C     *IN99         IFEQ      *OFF
     C*                                                                                       CAP059
     C*****FWCHTP        IFEQ      'A'                                               CAP059 BUG12772
     C     RECIX         IFNE      '*'                                                        253283
     C     FWCHTP        IFEQ      'A'                                                      AR746232
     C     FWCHTP        OREQ      'I'                                                      AR746232
     C     NAMD          ADD       1             NAMD
     C                   MOVE      BJRDNB        LCD
     C                   UPDATE    FWDRTFDF
     C                   ENDIF                                                              AR746232
     C                   ELSE                                                                 253283
     C**********         ENDIF                                                       CAP059 BUG12772
     C*                                                                                       CAP059
     C*****FWCHTP        IFEQ      'I'                                               CAP059 BUG12772
     C*****NINS          ADD       1             NINS                                CAP059 BUG12772
     C*****NORE          ADD       1             NORE                                CAP059 BUG12772
     C*****NLRA          ADD       1             NLRA                                CAP059 BUG12772
     C**********         MOVE      BJRDNB        LCD                                 CAP059 BUG12772
     C**********         UPDATE    FWDRTFDF                                          CAP059 BUG12772
     C**********         ENDIF                                                       CAP059 BUG12772
     C*                                                                                       CAP059
     C     NINS          ADD       1             NINS                                         253283
     C     NORE          ADD       1             NORE                                         253283
     C     NLRA          ADD       1             NLRA                                         253283
     C                   MOVE      BJRDNB        LCD                                          253283
     C                   UPDATE    FWDRTFDF                                                   253283
     C                   ENDIF                                                                253283
      *
      * Database error.
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'FWDRTFD '    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPSPOT -  Update the Spot Rate on the Currencies Files        *
      *                                                               *
      *****************************************************************
     C     UPSPOT        BEGSR
      *
      * Obtain the currency record.
      *
     C                   Z-ADD     50            MESLEN           15 5                        255602
     C                   CALL      'QCMDEXC'                                                  255602
     C                   PARM                    ##OX2                                        255602
     C                   PARM                    MESLEN                                       255602
      *                                                                                       255602
     C                   CALL      'AOCURRC0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FWCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @KEYCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '010'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      * Use the Spot Days to locate Spot Rate.
      * (If no element exists for spot days, first rate will be used).
      *
     C                   Z-ADD     A6SPDY        WSPDY             5 0
      *
     C                   MOVE      FWDFW         WDSDAY
     C                   MOVE      FWRFW         WDSRAT
      *
     C                   Z-ADD     1             N                 2 0
     C     WSPDY         LOOKUP    DAY(N)                                 90
      *
      * Update with Spot Rates.
      *
     C                   Z-ADD     RAT(N)        A6SPRT
     C                   Z-ADD     RAT(N)        A6ERLC
     C                   MOVE      'A'           A6TYLC
     C                   Z-ADD     BJRDNB        A6LCD
      *
      * Update the Currency Record.
      *
     C                   CALL      'AOCURRC0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*UPDATE'     @OPTN             7
     C                   PARM      *BLANKS       @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @KEYCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '011'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      * Close the update program
      *
     C                   CALL      'AOCURRC0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*CLOSE '     @OPTN             7
     C                   PARM      *BLANK        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '012'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CSD006
      /EJECT                                                                                  CSD006
      *****************************************************************                       CAP059
      *                                                               *                       CAP059
      * SrSETMDF  - Setup MDF Fields for Insert/Update                *                       CAP059
      *                                                               *                       CAP059
      *****************************************************************                       CAP059
     C     SrSETMDF      BEGSR                                                                CAP059
                                                                                              CAP059
      ** MDF Fields                                                                           CAP059
                                                                                              CAP059
     C                   IF        FWCHTP = 'I'                                               CAP059
     C                   EVAL      FRFRNT = *BLANKS                                           CAP059
     C                   ENDIF                                                                CAP059
     C                   EVAL      FRAFRT = FWAFRT                                            CAP059
     C                   EVAL      FRREPA = FWREPA                                            CAP059
                                                                                              CAP059
      ** Update timestamp for                                                                 CAP059
                                                                                              CAP059
     C                   MOVEL     TimeStamp     FRTMST                                       CAP059
                                                                                              CAP059
      ** MDF Fields                                                                           CAP059
                                                                                              CAP059
     C                   IF        CSD006 = 'Y'                                               CSD006
     C                   EVAL      FRDFTS = FWDFTS                                            CSD006
      ** MDF Data Request Identifier                                                          CSD006
                                                                                              CSD006
     C                   EVAL      FRDTRF = FWDTRF                                            CSD006
                                                                                              CSD006
      ** MDF Tolerance Exceeded Indicator                                                     CSD006
                                                                                              CSD006
     C                   EVAL      FRTLEX = *BLANK                                            CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
      /EJECT                                                                                  CSD006
     C****************************************************************                        CSD006
     C*                                                              *                        CSD006
     C* SDMDSR - Update Market Data Feed Files.                      *                        CSD006
     C*                                                              *                        CSD006
     C****************************************************************                        CSD006
     C     SDMDSR        BEGSR                                                                CSD006
      *                                                                                       CSD006
      * Retrieve record from Market Data Feed Requested Items Details                         CSD006
      * file and update if found                                                              CSD006
      *                                                                                       CSD006
     C                   EVAL      WKDITM = FWCCY                                             CSD006
     C     FIKEY         CHAIN     SDMDFIL0                                                   CSD006
     C                   IF        %FOUND(SDMDFIL0)                                           CSD006
     C                   EVAL      MITOLX = 'Y'                                               CSD006
     C                   UPDATE    SDMDFID0                                                   CSD006
      *                                                                                       CSD006
      * Retrieve record from Market Data Feed Requests Details file                           CSD006
      * and update if found                                                                   CSD006
      *                                                                                       CSD006
     C     FWDTRF        CHAIN     SDMDFRL0                                                   CSD006
     C                   IF        %FOUND(SDMDFRL0)                                           CSD006
     C                   EVAL      MRTOLX = 'Y'                                               CSD006
     C                   UPDATE    SDMDFRD0                                                   CSD006
     C                   ELSE                                                                 CSD006
     C                   UNLOCK    SDMDFRL0                                                   CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ELSE                                                                 CSD006
     C                   UNLOCK    SDMDFIL0                                                   CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
      /EJECT                                                                                  CSD006
     C****************************************************************                        CSD006
     C*                                                              *                        CSD006
     C* MDFHSR - Update Market Data Feed Rate/Price History file     *                        CSD006
     C*                                                              *                        CSD006
     C****************************************************************                        CSD006
     C     MDFHSR        BEGSR                                                                CSD006
      *                                                                                       CSD006
      * Update the fields before update                                                       CSD006
      *                                                                                       CSD006
     C                   EVAL      RHTREF = FWFRNT                                            CSD006
     C                   EVAL      RHDITM = FWCCY                                             CSD006
     C                   EVAL      RHDFTS = FWDFTS                                            CSD006
     C                   EVAL      RHDFRI = FWDTRF                                            CSD006
     C                   EVAL      RHPRCD = BJRDNB                                            CSD006
     C                   EVAL      RHTLEX = FWTLEX                                            CSD006
     C                   EVAL      RHFILE = 'FWDRTFE'                                         CSD006
     C                   EVAL      RHBIMG = B_FWDRTS                                          CSD006
     C                   EVAL      RHAIMG = FWDRTS                                            CSD006
                                                                                              CSD006
     C                   WRITE     SDMDFHD0                                                   CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Entry parameters.
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    FDVFWR
      *                                                                                       CSD006
      * Check for EURO currency name                                                          CSD006
      *                                                                                       CSD006
     C**********         CALLB     'AOGELRR0'                                          CSD006 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR'      @RTCD                                        CSD006
     C                   PARM      '*FIRST'      @OPTN                                        CSD006
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CSD006 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      * Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
                                                                                              CAP059
      ** Check whether this program should also update spot rates                             240882
     C                   CALLB     'AOSVALR0'                                                 240882
     C                   PARM      *BLANKS       PRtCd             7                          240882
     C                   PARM      PSysVal1      PSysVal01                                    240882
     C                   PARM                    PCurSet01                                    240882
     C                   PARM                    PSysVal02                                    240882
     C                   PARM                    PCurSet02                                    240882
     C                   PARM                    PSysVal03                                    240882
     C                   PARM                    PCurSet03                                    240882
     C                   PARM                    PSysVal04                                    240882
     C                   PARM                    PCurSet04                                    240882
     C                   PARM                    PSysVal05                                    240882
     C                   PARM                    PCurSet05                                    240882
     C                   PARM                    PSysVal06                                    240882
     C                   PARM                    PCurSet06                                    240882
     C                   PARM                    PSysVal07                                    240882
     C                   PARM                    PCurSet07                                    240882
     C                   PARM                    PSysVal08                                    240882
     C                   PARM                    PCurSet08                                    240882
     C                   PARM                    PSysVal09                                    240882
     C                   PARM                    PCurSet09                                    240882
     C                   PARM                    PSysVal10                                    240882
     C                   PARM                    PCurSet10                                    240882
                                                                                              240882
     C                   If        PRtCd <> *Blanks                                           240882
     C     *LOCK         In        LDA                                                        240882
     C                   Eval      DBFile = 'SDSVALPD'                                        240882
     C                   Eval      DBase = 8                                                  240882
     C                   Eval      DBKey = PSysVal01                                          240882
     C                   Out       LDA                                                        240882
     C                   ExSR      *PSSR                                                      240882
     C                   EndIf                                                                240882
                                                                                              240882
      * Isolate the first character of the current system value setting                       240882
     C                   MOVEL     PCurSet01     SPOTUPD           1                          240882
      ** Access SAR details file to see if CAP059 is installed.                               CAP059
                                                                                              CAP059
     C                   CALLB     'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'CAP059'      @SARD                                        CAP059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP059
                                                                                              CAP059
     C                   IF        @RTCD <> *Blanks AND                                       CAP059
     C                             @RTCD <> '*NRF   '                                         CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP059
     C                   Z-ADD     7             DBASE                                        CAP059
     C                   MOVEL     'CAP059'      DBKEY                                        CAP059
     C                   EXSR      *PSSR                                                      CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   IF        @RTCD = *Blanks                                            CAP059
     C                   MOVEL     'Y'           CAP059            1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVEL     'N'           CAP059                                       CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
                                                                                              CSD006
      ** Access SAR details file to see if CSD006 is installed.                               CSD006
                                                                                              CSD006
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD                                        CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks AND                                       CSD006
     C                             @RTCD <> '*NRF   '                                         CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD006
     C                   Z-ADD     7             DBASE                                        CSD006
     C                   MOVEL     'CSD006'      DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   IF        @RTCD = *Blanks                                            CSD006
     C                   MOVEL     'Y'           CSD006            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CSD006                                       CSD006
     C                   ENDIF                                                                CSD006
 
     C                   CALLB     'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CAP029'      @SARD                                        CSD006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD006
                                                                                              CSD006
     C                   IF        @RTCD <> *Blanks AND                                       CSD006
     C                             @RTCD <> '*NRF   '                                         CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD006
     C                   Z-ADD     7             DBASE                                        CSD006
     C                   MOVEL     'CAP029'      DBKEY                                        CSD006
     C                   EXSR      *PSSR                                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   IF        @RTCD = *Blanks                                            CSD006
     C                   MOVEL     'Y'           CAP029            1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVEL     'N'           CAP029                                       CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
      ** Access SAR details file to see if S01432 is installed.                               CAP059
                                                                                              CAP059
     C                   CALLB     'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'S01432'      @SARD                                        CAP059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP059
                                                                                              CAP059
     C                   IF        @RTCD <> *Blanks AND                                       CAP059
     C                             @RTCD <> '*NRF   '                                         CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP059
     C                   Z-ADD     7             DBASE                                        CAP059
     C                   MOVEL     'S01432'      DBKEY                                        CAP059
     C                   EXSR      *PSSR                                                      CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   IF        @RTCD = *Blanks                                            CAP059
     C                   MOVEL     'Y'           S01432            1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVEL     'N'           S01432                                       CAP059
     C                   ENDIF                                                                CAP059
      *                                                                                       CAP059
      ** Access SAR details file to see if CEU026 is installed.                               CAP059
                                                                                              CAP059
     C                   CALLB     'AOSARDR0'                                                 CAP059
     C                   PARM      *BLANKS       @RTCD                                        CAP059
     C                   PARM      '*VERIFY'     @OPTN                                        CAP059
     C                   PARM      'CEU026'      @SARD                                        CAP059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP059
                                                                                              CAP059
     C                   IF        @RTCD <> *Blanks AND                                       CAP059
     C                             @RTCD <> '*NRF   '                                         CAP059
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAP059
     C                   Z-ADD     7             DBASE                                        CAP059
     C                   MOVEL     'CEU026'      DBKEY                                        CAP059
     C                   EXSR      *PSSR                                                      CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CAP059
     C                   IF        @RTCD = *Blanks                                            CAP059
     C                   MOVEL     'Y'           CEU026            1                          CAP059
     C                   ELSE                                                                 CAP059
     C                   MOVEL     'N'           CEU026                                       CAP059
     C                   ENDIF                                                                CAP059
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CAP059
      * Key list for SDMDFIL0                                                                 CSD006
      *                                                                                       CSD006
     C     FIKEY         KLIST                                                                CSD006
     C                   KFLD                    FWDTRF                                       CSD006
     C                   KFLD                    WKDITM           20                          CSD006
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'FDFWRTUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
** ##OX1                                                                                      CAP059
OVRDBF FILE(FWDRT) SHARE(*NO)                                                                 CAP059
** ##OX2                                                                                      255602
OVRDBF FILE(SDCURRL1) SHARE(*NO)                                                              255602
