     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer Number Register')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000755 - Customer Number Register                          *
      *                                                               *
      *  Function:  This program will generate a report based on      *
      *             start and end customer numbers entered by user    *
      *             on the Customer Number Register Request Screen.   *
      *             The report contains a list of used & unused       *
      *             customer numbers (within the specified start and  *
      *             end numbers)                                      *
      *                                                               *
      *  Called By: SDC000755                                         *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027  *CREATE    Date 18Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Message Subfile SFLEND                          *
      *    03         Exit Customer# Register Request Screen          *
      *    50         Reverse-Image of Start Range screen field       *
      *    51         Reverse-Image of End Range screen field         *
      *    70         Page Overflow                                   *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *INZSR - Initialise                                           *
      * *PSSR  - Program error                                        *
      * REFRESH    - Refreshes the Customer# Request Screen           *
      * SNDMSG     - Send message to program message queue            *
      * GETMAXMIN  - Calculates *LOVAL/*HIVAL for Customer#           *
      * RPTGEN - Generates a report of used & unused Customer numbers *
      *          for the range entered on screen                      *
      * RTVSYSVAL - Retrieves all the required system values & stores *
      *             them in an array for later reference              *
      * PRINTDET  - Prints the details in the report                  *
      * VALIDCUST - Validates the Customer# as per rules specified    *
      *             across system values (CustAlphaAllow, etc)        *
      * READNEXT - Reads the next CustomerNo from SDCUSTPD            *
      * RANGE   - Finds and prints the range of used & unused         *
      *           customer numbers between two given numbers          *
      * RANGEU  - Finds and prints the range of unused customer       *
      *           numbers between two given numbers                   *
      * INCREMENT - Increments the customer number                    *
      * DECREMENT - Decrements the customer number                    *
      * NEXTVALID - Find the next valid character(s) for customer#    *
      * PREVVALID - Find the previous valid character(s) for customer#*
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Customer Number Register Request Screen
     FSD000755DFCF   E             WORKSTN
      *
      ** Customer Number Register Report
     FSD000755P1O    E             PRINTER OFLIND(*IN70) USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** LDA Layout
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Constant for System Value Prefix
     D WSysValPfx      C                   'CustAlphaAllow'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array containing valid/invalid flags for characters
      ** Layout is as follows:
      ** 216 elements = CustAlphaAllow(x)(y)   (x)=A-Z 0-9 & (y)=1-6
      ** A1 B1 ... 81 91   (For 1st char of Customer#)
      ** A2 B2 ... 82 92   (For 2nd char of Customer#)
      ** ...
      ** A6 B6 ... 86 96   (For 6th char of Customer#)
     D WValidArr       S              1A   DIM(216)
      *
      ** storing valid characters i.e. A-Z 0-9
     D WCharArr        S              1A   DIM(36) PERRCD(36) CTDATA
      *
      ** Max/Min customer# possible, as per rules
     D WMaxCust        S              1A   DIM(6)
     D WMinCust        S              1A   DIM(6)
      *
      ** Needed for AOBANKR0 access object
     D SDBANKDS      E DS                  EXTNAME(SDBANKPD)
     D DSFDYDS       E DS                  EXTNAME(DSFDY)
      *
      ** Needed for AOCUSTR0 access object
     D SDCUSTDS      E DS                  EXTNAME(SDCUSTPD)
     D DSSDYDS       E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1A
      ** Max/Min customer# possible, as per rules
     D WMaxCust#       S              6A
     D WMinCust#       S              6A
      *
     DWCusAlphaAllow   S            200A
     DWCusAlphaChksum  S            200A
      *
      ** Parameters for AOSVALR0 (Midas System Value Access Object)
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
      *
      ** Parameters for SDCUSTISO (Validate Customer# & Check Digit)
     D PCust           S              6A
     D PValid          S              6A
     D PCheckDigit     S              1A
      *
      ** Parameters for AOBANKR0/AOCUSTR0 access object
     D POption         S              7A
     D PKey            S             10A
     D PKyst           S              7A
      *
      ** Parameters for ZDATE2 program call
     D PDayNo          S              5  0
     D PDatFm          S              1A
     D PDate           S              6  0
     D PADate          S              7A
      *
      ** Parameters for SCC0240 program call
     D PUMSID          S              7A   INZ(*BLANKS)
     D PUMSGF          S             10A   INZ(*BLANKS)
      *
      ** Indicates the Detail-record type for report generation
     D WType           S              1A
      ** Record counter for report
     D WCount          S              6  0 INZ(*ZEROS)
      ** starting customer number
     D WStartCust      S              6A
      ** ending customer number
     D WEndCust        S              6A
      ** value to be incremented
     D WIncrCust       S              6A
      ** value to be decremented
     D WDecrCust       S              6A
      *
      ** customer# to be validated
     D WValidateCust   S              6A
      *
      ** Used in RANGE Subroutine
     D WStartRange     S              6A
     D WEndRange       S              6A
      ** Used in RANGEU Subroutine
     D WStart          S              6A
     D WEnd            S              6A
      *
      ** used for indexing
     D WIndx1          S              3  0
     D WIndx2          S              3  0
     D WIndx3          S              3  0
     D WIndx4          S              3  0
     D WIndx5          S              3  0
      *
     D WIsValid        S              1A
     D WTempN          S              6S 0
     D WFlag1          S              1A
     D WFlag2          S              1A
      *
 
      *********************************************************************
      /EJECT
      *********************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   Eval      DBPGM  = 'SD000755'
     C                   Eval      SPGMQ  = PSProcName
     C                   Eval      *IN02  = *ON
     C                   Eval      PUMSGF = 'SDUSRMSG'
      *
      ** Retrieve Bank details like Report Title and Rundate
     C                   Call(E)   'AOBANKR0'
     C                   Parm      *BLANKS       PRetCode
     C                   Parm      '*FIRST'      POption
     C     SDBANKDS      Parm      SDBANKDS      DSFDYDS
      ** If database error
     C                   If        PRetCode <> *BLANKS Or %Error Or
     C                             (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = POption
     C                   Eval      DBFILE = 'SDBANKPD'
     C                   Eval      DBASE = 1
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
      ** Formatting BJRDNB (RunDate, obtained from SDBANKPD) using ZDATE2
     C                   Call      'ZDATE2'
     C                   Parm      BJRDNB        PDayNo
     C                   Parm      *BLANKS       PDatFm
     C                   Parm                    PDate
     C                   Parm      *BLANKS       PADate
      *
      ** Setup the job name,program name & rundate on screen
     C                   Eval      SPROGNAME  = 'Ref: SD000755'
     C                   Eval      SJOBNAME   = PSJobName
     C                   Eval      SRUNDATE   = PADate
      *
      ** Retrieve relevant system values from SDSVALPD
     C                   ExSr      RtvSysVal
      *
      ** Calculate *LOVAL/*HIVAL customer#, for later reference
     C                   ExSr      GetMaxMin
      *
      ** Display Customer# Register Request Screen untill F3 is pressed
     C                   Dow       *IN03 = *OFF
     C                   Write     SD000755C0
      ** Display the Customer# Register Request Screen
     C                   Exfmt     CUSTNUM
      *
     C                   If        *IN03 = *ON
     C                   Leave
     C                   EndIf
      *
      ** Reset error indicators / message queue
     C                   ExSr      Refresh
      *
     C                   Eval      WStartCust = SSTCUST
     C                   Eval      WEndCust   = SEDCUST
      *
      ** If both Customer numbers are blank, display error on screen
     C                   If        WStartCust = *BLANKS And WEndCust = *BLANKS
     C                   Eval      *IN50 = *ON
     C                   Eval      *IN51 = *ON
     C                   Eval      PUMSID = 'S270008'
     C                   ExSr      SndMsg
     C                   Iter
     C                   EndIf
      *
      ** If one of the Customer numbers is blank, use *LOVAL/*HIVAL
     C                   If        WStartCust = *BLANKS Or WEndCust = *BLANKS
      ** Set blank Starting Customer# to *LOVAL
     C                   If        WStartCust = *BLANKS
     C                   Eval      WStartCust = WMinCust#
     C                   Eval      SSTCUST = WStartCust
      ** Set blank Ending Customer# to *HIVAL
     C                   ElseIf    WEndCust = *BLANKS
     C                   Eval      WEndCust = WMaxCust#
     C                   Eval      SEDCUST = WEndCust
     C                   EndIf
     C                   EndIf
      *
      ** If Start Customer# > End Customer#, display error on screen
     C                   If        WStartCust > WEndCust
     C                   Eval      *IN50 = *ON
     C                   Eval      PUMSID = 'S270007'
     C                   ExSr      SndMsg
     C                   Iter
     C                   EndIf
      *
      ** Pass the valid customer number range for report generation
     C                   If        Not %Open(SD000755P1)
     C                   Open      SD000755P1
     C                   EndIf
     C                   ExSr      RptGen
     C                   If        %Open(SD000755P1)
     C                   Close     SD000755P1
     C                   EndIf
      *
      ** Clear start/end customer# screen fields
     C                   Eval      SSTCUST = *BLANKS
     C                   Eval      SEDCUST = *BLANKS
      *
      ** Refresh the screen
     C                   ExSr      Refresh
      *
     C                   EndDo
      *
     C                   Eval      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * REFRESH - Refreshes the Customer# Request Screen              *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SCC0250                                                *
      *                                                               *
      *****************************************************************
     C     Refresh       BEGSR
      *
      ** Reset reverse-image indicators for Start/End customer#
     C                   Eval      *IN50 = *OFF
     C                   Eval      *IN51 = *OFF
      *
      ** Clear program message queue
     C                   Call      'SCC0250'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDMSG - Send message to program message queue                *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SCC0240                                                *
      *                                                               *
      *****************************************************************
     C     SndMsg        BEGSR
      *
     C                   Call      'SCC0240'
     C                   Parm                    PUMSID
     C                   Parm                    PUMSGF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GETMAXMIN -  Calculates *LOVAL/*HIVAL for Customer#           *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: SDCUSTISO                                              *
      *        *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     GetMaxMin     BEGSR
      *
     C                   If        WCusAlphaAllow = 'N'
     C                   MoveA     '999999'      WMaxCust
     C                   MoveA     '000000'      WMinCust
     C                   Else
      *
      ** If alphanumeric customer# & check digit
     C                   If        WCusAlphaChksum = 'Y'
     C                   Eval      WIndx3 = 5
      ** If alphanumeric customer# & no check digit
     C                   Else
     C                   Eval      WIndx3 = 6
     C                   EndIf
      *
     C                   For       WIndx1 = 1 To WIndx3
      ** For maximum valid char at position
     C                   For       WIndx2 = 36 Downto 1
     C                   Eval      WIsValid = WValidArr((WIndx1-1)*36 + WIndx2)
     C                   If        WIsValid = 'Y'
     C                   Eval      WMaxCust(WIndx1) = WCharArr(WIndx2)
     C                   Leave
     C                   EndIf
     C                   EndFor
      ** For minimum valid char at position
     C                   For       WIndx2 = 1 To 36
     C                   Eval      WIsValid = WValidArr((WIndx1-1)*36 + WIndx2)
     C                   If        WIsValid = 'Y'
     C                   Eval      WMinCust(WIndx1) = WCharArr(WIndx2)
     C                   Leave
     C                   EndIf
     C                   EndFor
     C                   EndFor
      *
      ** If check digit is enabled
     C                   If        WCusAlphaChksum = 'Y'
      ** For max customer#
     C                   MoveA     WMaxCust      PCust
     C                   Move      '9'           PCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 2
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
     C                   Eval      WMaxCust(6) = PCheckDigit
      *
      ** For min customer#
     C                   MoveA     WMinCust      PCust
     C                   Move      '0'           PCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
     C                   Eval      WMinCust(6) = PCheckDigit
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   MoveA     WMinCust      WMinCust#
     C                   MoveA     WMaxCust      WMaxCust#
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RPTGEN - Generates a report of used & unused Customer numbers *
      *          for the range entered on screen                      *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *        *PSSR                                                  *
      *        RANGE                                                  *
      *                                                               *
      *****************************************************************
     C     RptGen        BEGSR
      *
      ** Setup report header info
     C                   Eval      RBNKTITLE  = BJURPT
     C                   Eval      RREFERENCE = 'SD000755P1'
     C                   Eval      RPROGUSER  = PSUser
     C                   Eval      RRUNDATE   = SRUNDATE
     C                   Eval      RSTCUST    = WStartCust
     C                   Eval      REDCUST    = WEndCust
      *
      ** Print report header
     C                   Write     HEADER
      *
      ** Read Customer Numbers from SDCUSTPD
     C                   Call(E)   'AOCUSTR0'
     C                   Parm      *BLANKS       PRetCode
     C                   Parm      '*SETLL '     POption
     C                   Parm      WStartCust    PKey
     C                   Parm      *BLANKS       PKyst
     C     SDCUSTDS      Parm      SDCUSTDS      DSSDYDS
      ** If database error
     C                   If        (PRetCode <> *Blanks And
     C                             PRetCode <> '*EOF' And
     C                             PRetCode <> '*NRF') Or
     C                             %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBASE = 3
     C                   Eval      DBFILE = 'SDCUSTPD'
     C                   Eval      DBKEY  = POption
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
      ** Call subroutine for calculating used & unused customer numbers only
      ** if given range lies within (Minimum-Maximum customer#) range
     C                   Eval      WStartRange = WStartCust
     C                   Eval      WEndRange   = WEndCust
     C                   If        WEndRange >= WMinCust# And
     C                             WStartRange <= WMaxCust#
     C                   ExSr      Range
     C                   EndIf
      *
      ** If no details to print, then print 'No details to report'
     C                   If        WCount = *ZEROS
     C                   Write     NORECORD
     C                   EndIf
      *
      ** Print report footer
     C                   Write     TRAILER
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RTVSYSVAL - Retrieves all the required system values & stores *
      *             them in an array for later reference              *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: AOSVALR0                                               *
      *        *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     RtvSysVal     BEGSR
      *
      * Retrieve System Values 'CustAlphaAllow' & 'CustAlphaChecksum'
     C                   Eval      PRetCode = *BLANKS
     C                   Eval      PSysValK1 = 'CustAlphaAllow'
     C                   Eval      PSysVal1 = *BLANKS
     C                   Eval      PSysValK2 = 'CustAlphaChecksum'
     C                   Eval      PSysVal2 = *BLANKS
     C                   Call(E)   'AOSVALR0'    P_AOSVALR0
      * If database error
     C                   If        %Error Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = 'CustAlpha(Allow/Chksum)'
     C                   Eval      DBFILE = 'SDSVALPD'
     C                   Eval      DBASE = 4
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      WCusAlphaAllow  = PSysVal1
     C                   Eval      WCusAlphaChksum = PSysVal2
      *
      * Retrieve all CustAlphaAllow(x)(y) values, where (x)=(A-Z 0-9) & (y)=(1-6)
     C                   For       WIndx1 = 1 to 36
     C                   Eval      PSysValK1 = WSysValPfx + WCharArr(WIndx1)+'1'
     C                   Eval      PSysValK2 = WSysValPfx + WCharArr(WIndx1)+'2'
     C                   Eval      PSysValK3 = WSysValPfx + WCharArr(WIndx1)+'3'
     C                   Eval      PSysValK4 = WSysValPfx + WCharArr(WIndx1)+'4'
     C                   Eval      PSysValK5 = WSysValPfx + WCharArr(WIndx1)+'5'
     C                   Eval      PSysValK6 = WSysValPfx + WCharArr(WIndx1)+'6'
     C                   Eval      PSysVal1 = *BLANKS
     C                   Eval      PSysVal2 = *BLANKS
     C                   Eval      PSysVal3 = *BLANKS
     C                   Eval      PSysVal4 = *BLANKS
     C                   Eval      PSysVal5 = *BLANKS
     C                   Eval      PSysVal6 = *BLANKS
     C                   Call(E)   'AOSVALR0'    P_AOSVALR0
      * If database error
     C                   If        %Error Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = 'CustAlphaAllow(x)(y)'
     C                   Eval      DBFILE = 'SDSVALPD'
     C                   Eval      DBASE = 5
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
      * Store the retrieved values in array WValidArr
     C                   Eval      WValidArr(WIndx1)     = PSysVal1
     C                   Eval      WValidArr(WIndx1+36)  = PSysVal2
     C                   Eval      WValidArr(WIndx1+72)  = PSysVal3
     C                   Eval      WValidArr(WIndx1+108) = PSysVal4
     C                   Eval      WValidArr(WIndx1+144) = PSysVal5
     C                   Eval      WValidArr(WIndx1+180) = PSysVal6
      *
     C                   EndFor
      *
      ** Translate 'Allow/Disallow' to 'Yes/No' values
     C                   Eval      WValidArr = %Xlate('AD':'YN':WValidArr)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RANGE - Finds and prints the range of used and unused         *
      *         customer numbers between two given numbers            *
      *                                                               *
      * Called by: RPTGEN                                             *
      *                                                               *
      * Calls: RANGEU                                                 *
      *        VALIDCUST                                              *
      *        PRINTDET                                               *
      *        READNEXT                                               *
      *        INCREMENT                                              *
      *        DECREMENT                                              *
      *                                                               *
      *****************************************************************
     C     Range         BEGSR
      *
      ** Loop untill range is completely processed
     C                   DoW       '1'
      *
     C                   Select
      *
      ** (No Records present in SDCUSTPD) Or (StartRange > Max Customer# in SDCUSTPD)
     C                   When      PRetCode = '*NRF' Or PRetCode = '*EOF'
      *
      ** Find & print unused range for ( StartRange , EndRange )
     C                   Eval      WStart = WStartRange
     C                   Eval      WEnd   = WEndRange
     C                   ExSr      RangeU
     C                   Leave
      *
     C                   When      BBCUST < WStartRange
     C                   Eval      WStartRange = BBCUST
      *
     C                   When      WStartRange = WEndRange And
     C                             BBCUST <> WStartRange
     C                   Eval      WValidateCust = WStartRange
     C                   ExSr      ValidCust
     C                   If        WIsValid  = 'Y'
      ** Print Unused CustomerNo ( StartRange )
     C                   Eval      WType = '4'
     C                   Eval      RCUSTNUM = WStartRange
     C                   ExSr      PrintDet
     C                   EndIf
     C                   Leave
      *
     C                   When      WStartRange = WEndRange And
     C                             BBCUST = WStartRange
      ** Print Used CustomerNo ( StartRange )
     C                   Eval      WType = '1'
     C                   Eval      RCUSTNUM = WStartRange
     C                   ExSr      PrintDet
     C                   Leave
      *
     C                   When      WStartRange = BBCUST
      ** Print Used CustomerNo ( StartRange )
     C                   Eval      WType = '1'
     C                   Eval      RCUSTNUM = WStartRange
     C                   ExSr      PrintDet
      *
     C                   Eval      WIncrCust = WStartRange
     C                   ExSr      Increment
      ** Read next CustomerNo from file
     C                   ExSr      ReadNext
     C                   Eval      WStartRange = WIncrCust
     C                   Eval      WEndRange   = WEndRange
      ** Call again for ( StartRange+1 , EndRange )
      *
      ** StartRange < Customer# (from file) < EndRange
     C                   When      WStartRange < BBCUST And BBCUST < WEndRange
      *
      ** Find & print unused range for ( StartRange , Customer#-1 )
     C                   Eval      WDecrCust = BBCUST
     C                   ExSr      Decrement
     C                   Eval      WStart = WStartRange
     C                   Eval      WEnd   = WDecrCust
     C                   ExSr      RangeU
      *
      ** Print Used CustomerNo ( Customer# )
     C                   Eval      WType = '1'
     C                   Eval      RCUSTNUM = BBCUST
     C                   ExSr      PrintDet
      *
     C                   Eval      WIncrCust = BBCUST
     C                   ExSr      Increment
      ** Read next CustomerNo from file
     C                   ExSr      ReadNext
     C                   Eval      WStartRange = WIncrCust
     C                   Eval      WEndRange   = WEndRange
      ** Call again for ( Customer#+1 , EndRange )
      *
     C                   When      WEndRange = BBCUST
      ** Find & print unused range for ( StartRange , EndRange-1 )
     C                   Eval      WDecrCust = WEndRange
     C                   ExSr      Decrement
     C                   Eval      WStart = WStartRange
     C                   Eval      WEnd   = WDecrCust
     C                   ExSr      RangeU
      *
      ** Print Used CustomerNo ( EndRange )
     C                   Eval      WType = '1'
     C                   Eval      RCUSTNUM = WEndRange
     C                   ExSr      PrintDet
     C                   Leave
      *
     C                   When      BBCUST > WEndRange
      ** Find & print unused range for ( StartRange , EndRange )
     C                   Eval      WStart = WStartRange
     C                   Eval      WEnd   = WEndRange
     C                   ExSr      RangeU
     C                   Leave
      *
     C                   EndSl
      *
     C                   EndDo
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RANGEU - Finds and prints the range of unused customer        *
      *          numbers between two given numbers                    *
      *                                                               *
      * Called by: RANGE                                              *
      *                                                               *
      * Calls: VALIDCUST                                              *
      *        PRINTDET                                               *
      *        INCREMENT                                              *
      *        DECREMENT                                              *
      *                                                               *
      *****************************************************************
     C     RangeU        BEGSR
      *
     C                   Eval      WValidateCust = WStart
     C                   ExSr      ValidCust
     C                   If        WIsValid  = 'N'
      ** Set WStart to next valid customer#
     C                   Eval      WIncrCust = WStart
     C                   ExSr      Increment
     C                   If        WIncrCust > WEnd
     C                   LeaveSr
     C                   EndIf
     C                   Eval      WStart = WIncrCust
     C                   Else
     C                   Eval      WFlag1 = 'Y'
     C                   EndIf
      *
     C                   Eval      WValidateCust = WEnd
     C                   ExSr      ValidCust
     C                   If        WIsValid  = 'N'
      ** Set WEnd to previous valid customer#
     C                   Eval      WDecrCust = WEnd
     C                   ExSr      Decrement
     C                   Eval      WEnd = WDecrCust
     C                   Else
     C                   Eval      WFlag2 = 'Y'
     C                   EndIf
      *
     C                   If        WFlag1 = 'Y' or WFlag2 = 'Y'
     C                   If        WStart = WEnd
      ** Print Unused CustomerNo ( Start )
     C                   Eval      WType = '4'
     C                   Eval      RCUSTNUM = WStart
     C                   ExSr      PrintDet
     C                   Else
      ** Print Unused Range ( Start , End )
     C                   Eval      WType = '2'
     C                   Eval      RCUSTNUM = WStart
     C                   ExSr      PrintDet
     C                   Eval      WType = '3'
     C                   Eval      RCUSTNUM = WEnd
     C                   ExSr      PrintDet
     C                   EndIf
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VALIDCUST - Validates the Customer# as per rules specified    *
      *             across system values (CustAlphaAllow, etc)        *
      *                                                               *
      * Called by: RANGE                                              *
      *            RANGEU                                             *
      *            INCREMENT                                          *
      *            DECREMENT                                          *
      *                                                               *
      * Calls: SDCUSTISO                                              *
      *        *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     ValidCust     BEGSR
      *
     C                   Eval      WIsValid = 'Y'
      *
      ** If Alphanumeric customer# and checksum enabled
     C                   If        WCusAlphaAllow = 'Y' And
     C                             WCusAlphaChksum = 'Y'
      *
      ** For calculating check digit
     C                   Eval      PCust = WValidateCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 6
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      ** If check digit is invalid
     C                   If        PValid <> *BLANKS
     C                   Eval      WIsValid = 'N'
     C                   EndIf
      *
     C                   Else
      *
     C                   For       WIndx4 = 6 Downto 1
      *
     C                   Eval      WIndx5 = %Lookup( %Subst(WValidateCust:
     C                                               WIndx4:1) : WCharArr )
      *
     C                   If        WIndx5 <= 0
     C                   Eval      WIsValid = 'N'
     C                   LeaveSr
      *
      ** If alpha customer# not allowed, validate in (0-9)
     C                   ElseIf    WCusAlphaAllow = 'N' And WIndx5 < 27
     C                   Eval      WIsValid = 'N'
     C                   LeaveSr
      *
      ** If alpha customer# allowed, validate in (A-Z 0-9) & WValidArr
     C                   ElseIf    WCusAlphaAllow = 'Y'
     C                             And
     C                             WValidArr( (WIndx4-1)*36 + WIndx5) = 'N'
     C                   Eval      WIsValid = 'N'
     C                   LeaveSr
     C                   EndIf
      *
     C                   EndFor
      *
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INCREMENT - Increments the customer number                    *
      *                                                               *
      * Called by: RANGE                                              *
      *            RANGEU                                             *
      *                                                               *
      * Calls: VALIDCUST                                              *
      *        NEXTVALID                                              *
      *        SDCUSTISO                                              *
      *                                                               *
      *****************************************************************
     C     Increment     BEGSR
      *
     C                   Eval      WFlag1 = 'N'
     C                   Eval      WValidateCust = WIncrCust
     C                   ExSr      ValidCust
      *
      ** Increment only if not maximum
     C                   If        WIncrCust <> WMaxCust#
      *
      ** If valid customer# then do a normal increment
     C                   If        WIsValid = 'Y'
     C                             Or
     C                             ( WCusAlphaAllow = 'Y' And
     C                               WCusAlphaChksum = 'Y' And
     C                             %Subst(PValid:1:5) = *BLANKS )
      *
      ** Incrementing a numeric CustomerNo
     C                   If        WCusAlphaAllow = 'N'
     C                   Move      WIncrCust     WTempN
     C                   Eval      WTempN += 1
     C                   Move      WTempN        WIncrCust
     C                   Eval      WFlag1 = 'Y'
     C                   LeaveSr
      *
      ** Incrementing an alphanumeric CustomerNo with Checksum disabled
     C                   ElseIf    WCusAlphaAllow  = 'Y' And
     C                             WCusAlphaChksum = 'N'
      *
     C                   Eval      WIndx1 = 6
     C                   Eval      WTempN = 1
     C                   ExSr      NextValid
      *
      ** Incrementing an alphanumeric CustomerNo with Checksum enabled
     C                   ElseIf    WCusAlphaAllow  = 'Y' And
     C                             WCusAlphaChksum = 'Y'
      *
      ** Calculate CheckDigit
     C                   Eval      PCust = WIncrCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 7
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   If        PCheckDigit > %Subst(WIncrCust:6:1)
     C                   Eval      %Subst(WIncrCust:6:1) = PCheckDigit
     C                   Eval      WFlag1 = 'Y'
     C                   LeaveSr
      *
      ** Increment if not maximum
     C                   ElseIf    %Subst(WIncrCust:1:5) <>
     C                             %Subst(WMaxCust#:1:5)
      *
      ** Do an increment on the first 5 chars of customer#
     C                   Eval      WIndx1 = 5
     C                   Eval      WTempN = 1
     C                   ExSr      NextValid
      *
      ** Calculate CheckDigit
     C                   Eval      PCust = WIncrCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 8
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      %Subst(WIncrCust:6:1) = PCheckDigit
     C                   Eval      WFlag1 = 'Y'
     C                   LeaveSr
      *
     C                   EndIf
      ** End of "Increment if not maximum" check
      *
     C                   EndIf
      ** End of "Alpha/Checksum combinations" check
      *
      *
      *
      *
      ** If invalid customer# then search for next valid customer#
     C                   Else
      *
      ** Incrementing a numeric CustomerNo
     C                   If        WCusAlphaAllow = 'N'
      *
      ** Search for first invalid character and convert all digits starting from that
      ** position to 0 and then increment the number
     C                   Eval      WIndx1 = %Check('0123456789':WIncrCust)
     C                   For       WIndx1 = WIndx1 to 6
     C                   Eval      %Subst(WIncrCust:WIndx1:1) = WMinCust(WIndx1)
     C                   EndFor
      *
     C                   Move      WIncrCust     WTempN
     C                   Eval      WTempN += 1
     C                   Move      WTempN        WIncrCust
     C                   Eval      WFlag1 = 'Y'
     C                   LeaveSr
      *
      ** Incrementing an alphanumeric CustomerNo
     C                   Else
      *
      ** Find the next valid customer#
     C                   For       WIndx4 = 1 to 6
     C                   Eval      WIndx5 = %Lookup( %Subst(WIncrCust:WIndx4:1):
     C                                               WCharArr:1 )
     C                   If        WIndx5 = 0
     C                   Eval      %Subst(WIncrCust:WIndx4:1) = WMinCust(WIndx4)
     C                   Eval      WTempN = -1
     C                   Leave
     C                   ElseIf    WValidArr( (WIndx4-1)*36 + WIndx5 ) = 'N'
      *
     C                   Eval      WFlag2 = %Subst(WIncrCust:WIndx4:1)
     C                   Eval      WIndx1 = WIndx4
     C                   Eval      WTempN = WIndx4
     C                   ExSr      NextValid
      *
      ** If valid char was not found at position, search at the previous position
     C                   If        WFlag2 = %Subst(WIncrCust:WIndx4:1)
     C                   Eval      %Subst(WIncrCust:WIndx4:1) = WMinCust(WIndx4)
     C                   Eval      WIndx1 = WIndx4 - 1
     C                   Eval      WTempN = 1
     C                   ExSr      NextValid
     C                   EndIf
     C                   Eval      WTempN = -1
     C                   Leave
      *
     C                   EndIf
      *
     C                   EndFor
     C                   For       WIndx4 = WIndx4 to 6
     C                   If        WTempN = -1
     C                   Eval      WTempN = 0
     C                   Iter
     C                   EndIf
     C                   Eval      %Subst(WIncrCust:WIndx4:1) = WMinCust(WIndx4)
     C                   EndFor
      *
     C                   EndIf
      ** End of "Alpha/Numeric Customer#" check
      *
      ** If Alpha customer# and checksum enabled
     C                   If        WCusAlphaAllow = 'Y' And
     C                             WCusAlphaChksum = 'Y'
      ** Calculate CheckDigit
     C                   Eval      PCust = WIncrCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 9
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      %Subst(WIncrCust:6:1) = PCheckDigit
     C                   EndIf
      *
     C                   Eval      WValidateCust = WIncrCust
     C                   ExSr      ValidCust
     C                   If        WIsValid = 'Y'
     C                   Eval      WFlag1 = 'Y'
     C                   LeaveSr
     C                   EndIf
      *
     C                   EndIf
      ** End of "Valid/Invalid Customer#" check
      *
     C                   EndIf
      ** End of "Increment only if not maximum" check
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DECREMENT - Decrements the customer number                    *
      *                                                               *
      * Called by: RANGE                                              *
      *            RANGEU                                             *
      *                                                               *
      * Calls: VALIDCUST                                              *
      *        PREVVALID                                              *
      *        SDCUSTISO                                              *
      *        *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     Decrement     BEGSR
      *
     C                   Eval      WFlag2 = 'N'
     C                   Eval      WValidateCust = WDecrCust
     C                   ExSr      ValidCust
      *
      ** Decrement only if not minimum
     C                   If        WDecrCust <> WMinCust#
      *
      ** If valid customer# then do a normal decrement
     C                   If        WIsValid = 'Y'
     C                             Or
     C                             ( WCusAlphaAllow = 'Y' And
     C                               WCusAlphaChksum = 'Y' And
     C                             %Subst(PValid:1:5) = *BLANKS )
      *
      ** Decrementing a numeric CustomerNo
     C                   If        WCusAlphaAllow = 'N'
     C                   Move      WDecrCust     WTempN
     C                   Eval      WTempN -= 1
     C                   Move      WTempN        WDecrCust
     C                   Eval      WFlag2 = 'Y'
     C                   LeaveSr
      *
      ** Decrementing an alphanumeric CustomerNo with Checksum disabled
     C                   ElseIf    WCusAlphaAllow  = 'Y' And
     C                             WCusAlphaChksum = 'N'
      *
     C                   Eval      WIndx1 = 6
     C                   Eval      WTempN = 1
     C                   ExSr      PrevValid
      *
      ** Decrementing an alphanumeric CustomerNo with Checksum enabled
     C                   ElseIf    WCusAlphaAllow  = 'Y' And
     C                             WCusAlphaChksum = 'Y'
      *
      ** Calculate CheckDigit
     C                   Eval      PCust = WDecrCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 10
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   If        PCheckDigit < %Subst(WDecrCust:6:1)
     C                   Eval      %Subst(WDecrCust:6:1) = PCheckDigit
     C                   Eval      WFlag2 = 'Y'
     C                   LeaveSr
      *
      ** Decrement if not minimum
     C                   ElseIf    %Subst(WDecrCust:1:5) <>
     C                             %Subst(WMinCust#:1:5)
      *
      ** Do a decrement on the first 5 chars of customer#
     C                   Eval      WIndx1 = 5
     C                   Eval      WTempN = 1
     C                   ExSr      PrevValid
      *
      ** Calculate CheckDigit
     C                   Eval      PCust = WDecrCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 11
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      %Subst(WDecrCust:6:1) = PCheckDigit
     C                   Eval      WFlag2 = 'Y'
     C                   LeaveSr
      *
     C                   EndIf
      ** End of "Decrement if not minimum" check
      *
     C                   EndIf
      ** End of "Alpha/Checksum combinations" check
      *
      *
      *
      *
      ** If invalid customer# then search for previous valid customer#
     C                   Else
      *
      ** Decrementing a numeric CustomerNo
     C                   If        WCusAlphaAllow = 'N'
      *
      ** Search for first invalid character and convert all digits starting from that
      ** position to 0 and then decrement the number
     C                   Eval      WIndx1 = %Check('0123456789':WDecrCust)
     C                   For       WIndx1 = WIndx1 to 6
     C                   Eval      %Subst(WDecrCust:WIndx1:1) = WMinCust(WIndx1)
     C                   EndFor
      *
     C                   Move      WDecrCust     WTempN
     C                   Eval      WTempN -= 1
     C                   Move      WTempN        WDecrCust
     C                   Eval      WFlag2 = 'Y'
     C                   LeaveSr
      *
      ** Decrementing an alphanumeric CustomerNo
     C                   Else
      *
      ** Find the previous valid customer#
     C                   For       WIndx4 = 1 to 6
     C                   Eval      WIndx5 = %Lookup( %Subst(WDecrCust:WIndx4:1):
     C                                               WCharArr:1 )
     C                   If        WIndx5 = 0
     C                   Eval      %Subst(WDecrCust:WIndx4:1) = WMinCust(WIndx4)
     C                   Eval      WTempN = -1
     C                   Leave
     C                   ElseIf    WValidArr( (WIndx4-1)*36 + WIndx5 ) = 'N'
      *
     C                   Eval      WFlag1 = %Subst(WDecrCust:WIndx4:1)
     C                   Eval      WIndx1 = WIndx4
     C                   Eval      WTempN = WIndx4
     C                   ExSr      PrevValid
      *
      ** If valid char was not found at position, search at the previous position
     C                   If        WFlag1 = %Subst(WDecrCust:WIndx4:1)
     C                   Eval      %Subst(WDecrCust:WIndx4:1) = WMaxCust(WIndx4)
     C                   Eval      WIndx1 = WIndx4 - 1
     C                   Eval      WTempN = 1
     C                   ExSr      PrevValid
     C                   EndIf
     C                   Eval      WTempN = -1
     C                   Leave
      *
     C                   EndIf
      *
     C                   EndFor
     C                   For       WIndx4 = WIndx4 to 6
     C                   If        WTempN = -1
     C                   Eval      WTempN = 0
     C                   Iter
     C                   EndIf
     C                   Eval      %Subst(WDecrCust:WIndx4:1) = WMaxCust(WIndx4)
     C                   EndFor
      *
     C                   EndIf
      ** End of "Alpha/Numeric Customer#" check
      *
      ** If Alpha customer# and checksum enabled
     C                   If        WCusAlphaAllow = 'Y' And
     C                             WCusAlphaChksum = 'Y'
      ** Calculate CheckDigit
     C                   Eval      PCust = WDecrCust
     C                   Eval      PValid = *BLANKS
     C                   Eval      PCheckDigit = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      ** If error
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBKEY = PCust
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 12
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      %Subst(WDecrCust:6:1) = PCheckDigit
     C                   EndIf
      ** End of "If Alpha customer# and checksum enabled" check
      *
     C                   Eval      WValidateCust = WDecrCust
     C                   ExSr      ValidCust
     C                   If        WIsValid = 'Y'
     C                   Eval      WFlag2 = 'Y'
     C                   LeaveSr
     C                   EndIf
      *
     C                   EndIf
      ** End of "Valid/Invalid Customer#" check
      *
     C                   EndIf
      ** End of "Decrement only if not minimum" check
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * NEXTVALID - Find the next valid character(s) for customer#    *
      *                                                               *
      * Called by: INCREMENT                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     NextValid     BEGSR
      *
     C                   For       WIndx1 = WIndx1 Downto WTempN
     C                   If        %Subst(WIncrCust:WIndx1:1) = WMaxCust(WIndx1)
     C                   Eval      %Subst(WIncrCust:WIndx1:1) = WMinCust(WIndx1)
     C                   Else
      ** Starting search position in WValidArr
     C                   Eval      WIndx2 = %Lookup(%Subst(WIncrCust:WIndx1:1):
     C                                              WCharArr) + 1 +
     C                                      (WIndx1-1) * 36
      ** Ending search position in WValidArr
     C                   Eval      WIndx3 = 36 + (WIndx1-1) * 36
      ** Search for next valid character
     C                   Eval      WIndx3 = %Lookup('Y':WValidArr:WIndx2:
     C                                               WIndx3-WIndx2+1)
     C                   If        WIndx3 <> 0
     C                   Eval      WIndx3 = %Rem(WIndx3:36)
     C                   If        WIndx3 = 0
     C                   Eval      WIndx3 = 36
     C                   EndIf
      ** Set to next valid character
     C                   Eval      %Subst(WIncrCust:WIndx1:1) = WCharArr(WIndx3)
     C                   Eval      WFlag1 = 'Y'
     C                   LeaveSr
     C                   EndIf
     C                   EndIf
     C                   EndFor
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PREVVALID - Find the previous valid character(s) for customer#*
      *                                                               *
      * Called by: DECREMENT                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PrevValid     BEGSR
      *
     C                   For       WIndx1 = WIndx1 Downto WTempN
     C                   If        %Subst(WDecrCust:WIndx1:1) = WMinCust(WIndx1)
     C                   Eval      %Subst(WDecrCust:WIndx1:1) = WMaxCust(WIndx1)
     C                   Else
      ** Starting search position in WValidArr
     C                   Eval      WIndx2 = %Lookup(%Subst(WDecrCust:WIndx1:1):
     C                                              WCharArr) - 1 +
     C                                      (WIndx1-1) * 36
      ** Search for prev valid character
     C                   For       WIndx3 = WIndx2 Downto (1 + (WIndx1-1) * 36)
      ** If a valid character is found
     C                   If        WValidArr(WIndx3) = 'Y'
     C                   Eval      WIndx3 = %Rem(WIndx3:36)
     C                   If        WIndx3 = 0
     C                   Eval      WIndx3 = 36
     C                   EndIf
      ** Set to prev valid character
     C                   Eval      %Subst(WDecrCust:WIndx1:1) = WCharArr(WIndx3)
     C                   Eval      WFlag2 = 'Y'
     C                   LeaveSr
     C                   EndIf
     C                   EndFor
     C                   EndIf
     C                   EndFor
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PRINTDET - Prints the details in the report                   *
      *                                                               *
      * Called by: RANGE                                              *
      *            RANGEU                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     PrintDet      BEGSR
      *
      ** Handle Page overflow
     C                   If        *IN70 = *ON
     C                   Eval      *IN70 = *OFF
     C                   Write     HEADER
     C                   EndIf
      *
     C                   Select
      *
      ** Used Customer# (with details)
     C                   When      WType = '1'
     C                   Eval      RCUSTSHORT = BBCSSN
     C                   Eval      RCUSTADDR1 = BBCNA1
     C                   Eval      RCUSTADDR2 = BBCNA2
      ** Customer Status
     C                   If        BBTYLC     = 'D'
     C                   Eval      RCUSTSTAT  = 'DELETED'
     C                   Else
     C                   Eval      RCUSTSTAT  = ' '
     C                   EndIf
     C                   Write     DETAIL1
      *
      ** Customer# Unused Start Range
     C                   When      WType = '2'
     C                   Write     DETAIL2
      *
      ** Customer# Unused End Range
     C                   When      WType = '3'
     C                   Write     DETAIL3
      *
      ** Unused Customer# (reported individually)
     C                   When      WType = '4'
     C                   Write     DETAIL4
      *
     C                   EndSl
      *
     C                   Eval      WCount += 1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * READNEXT - Reads the next customer# from SDCUSTPD             *
      *                                                               *
      * Called by: RANGE                                              *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *        *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     ReadNext      BEGSR
      *
     C                   Call(E)   'AOCUSTR0'
     C                   Parm      *BLANKS       PRetCode
     C                   Parm      '*NEXT  '     POption
     C                   Parm      *BLANKS       PKey
     C                   Parm      *BLANKS       PKyst
     C     SDCUSTDS      Parm      SDCUSTDS      DSSDYDS
      ** If error
     C                   If        (PRetCode <> *BLANKS And
     C                             PRetCode <> '*NRF'   And
     C                             PRetCode <> '*EOF') Or
     C                             %Error Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBASE = 13
     C                   Eval      DBFILE = 'SDCUSTPD'
     C                   Eval      DBKEY = POption
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter list for calling AOSVALR0
     C     P_AOSVALR0    PList
     C                   Parm                    PRetCode
     C                   Parm                    PSysValK1
     C                   Parm                    PSysVal1
     C                   Parm                    PSysValK2
     C                   Parm                    PSysVal2
     C                   Parm                    PSysValK3
     C                   Parm                    PSysVal3
     C                   Parm                    PSysValK4
     C                   Parm                    PSysVal4
     C                   Parm                    PSysValK5
     C                   Parm                    PSysVal5
     C                   Parm                    PSysValK6
     C                   Parm                    PSysVal6
     C                   Parm                    PSysValK7
     C                   Parm                    PSysVal7
     C                   Parm                    PSysValK8
     C                   Parm                    PSysVal8
     C                   Parm                    PSysValK9
     C                   Parm                    PSysVal9
     C                   Parm                    PSysValK10
     C                   Parm                    PSysVal10
      *
      ** Parameter list for calling SDCUSTISO
     C     P_SDCUSTISO   PList
     C                   Parm                    PCust
     C                   Parm                    PValid
     C                   Parm                    PCheckDigit
     C                   Parm                    @Data             2                          249076
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using ExSr.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: MAIN                                               *
      *            GETMAXMIN                                          *
      *            RPTGEN                                             *
      *            RTVSYSVAL                                          *
      *            VALIDCUST                                          *
      *            INCREMENT                                          *
      *            DECREMENT                                          *
      *            READNEXT                                           *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   If        WRun = *BLANKS
     C                   Eval      WRun = 'Y'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Dump
     C                   Eval      *INLR = *ON
     C                   Call      'DBERRCTL'
     C                   EndIf
      *
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      * Compile-Time Array Data
      *
**CTDATA WCharArr
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
