     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Header Validation Control')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITHVAL - Journal Batch Entry Header Validation            *
      *              Control                                          *
      *                                                               *
      *  Function: This module validates Journal Batch Entry header   *
      *            fields for input into Midas database.              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. AR850162           Date 01Jun20               *      
      *  Prev Amend No. MD054696           Date 29Oct19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL182             Date 11May17               *
      *                 246752             Date 29Oct15               *
      *                 MD027587           Date 19Jun14               *
      *                 AR1078953          Date 18Jan13               *
      *                 AR1070246          Date 08Jan13               *
      *                 CGL130             Date 28Sep12               *
      *                 AR996631           Date 28Jun12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER046             Date 19May08               *
      *                 260029             Date 29Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15754           Date 30Jan08               *
      *                 248749             Date 03Jul07               *
      *                 BUG13869           Date 04May07               *
      *                 243860             Date 20Nov06               *
      *                 BUG13181           Date 31Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12820           Date 05Dec06               *
      *                 241505             Date 25Aug06               *
      *                 237512             Date 12Apr06               *
      *                 BUG11734           Date 24Jul06               *
      *                 240063             Date 06Jun06               *
      *                 240107             Date 26May06               *
      *                 240080             Date 24May06               *
      *                 239608             Date 05May06               *
      *                 BUG7895            Date 18Jul05               *
      *                 BUG8550            Date 07Oct05               *
      *                 BUG6008            Date 25Feb05               *
      *                 BUG5821            Date 09Feb05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG3546            Date 20Aug04               *
      *                 BUG3899            Date 02Aug04               *
      *                 BUG2948            Date 03Jun04               *
      *                 BUG711             Date 19Mar04               *
      *                 CAP084             Date 12Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP032  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR850162 - Batches were not held due to wrong summary of     *
      *             totals and wrong checking of multi-branch ind.    *
      *             Applied fix 263436 and changed checking of        *
      *             amended multi-branch ind. value only during       *
      *             amendments. (Child: AR850163)                     *
      *           - Applied for MD-35908                              *      
      *  MD054696 - Journal Entries Avoid Shadow Postings Update.     *
      *             Add Shadow Post Indicator in BITH API (SOAP/JMS). *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *  246752 - Batches remain Held after Accepting. Wrong valida-  *
      *           tion for Single Branch. Applied for MD034561        *
      *  MD027587 - Unable to use the C for Copy and T for Template   *
      *             (Recompile)                                       *
      *  AR1078953 - Blank Batch Number is not accepted by the system *
      *  AR1070246 - Event code for message ID GLX0431 not found.     *
      *              Replace message ID with event code to display    *
      *              the correct error message.                       *
      *  CGL130 - GL Batch Number Using Alphabetical Characters       *
      *  AR996631 - System should not validate deal number range      *
      *             in PEA system                                     *
      *  CSC054 - Period End Adjustments                              *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,GLH00050                                 *
      *             WNCPYSRC,GLH00051                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER046 - German Features LF033-00 Payments & Clearing        *
      *           Apply 241505A                                       *
      *  241505A- Correct message ID index for error arrays to        *
      *           display all error messages                          *
      *  260029 - Applied core fix 251260.                            *
      *  251260 - Journal entry hash item no. do not match. Increase  *
      *           length of field DDHINC from 2A to 3A (Recompile).   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15754 - Applied fix 249471.                               *
      *  249471 - Calculated Hash Total and No. of Items added to     *
      *           Header input screen.  Recompiled only.              *
      *  248749  - Add a validation for Account Code                  *
      *  BUG13869 - Error message change in GLBITHVAL                 *
      *  243860  - No detail entries written on GLJENPPD              *
      *  BUG13181 - There was an overlap between 240107 and 239608.   *
      *             Will remove 239608 to allow auto-generation of    *
      *             batch number.                                     *
/*    *  BUG12820- Handle GLX0168 error msg id validation             *
      *  241505 - Before accepting a batch determine first if there   *
      *           are no batch in error.                              *
      *  237512  - pass the value of BKMHTN to module GLVNBIM02.      *
      *  BUG11734- fix bug 239608 to allow batch number field to      *
      *            be filled with proper entry before the valida-     *
      *            tion.                                              *
      *  240063  - pass the value of BKMHTN to module GLVNBIM02.      *
      *            Applied fix 237512.                                *
      *  240107  - System should only allow numeric or blank value    *
      *            on the batch number.                               *
      *  237512  - pass the value of BKMHTN to module GLVNBIM02.      *
      *  240080 - Allow default of branch code and department code    *
      *           from the user when they are left blanks.            *
      *  239608  - system should only allow numeric entry for batch   *
      *            number and should not allow blank or zero entry.   *
      *  BUG7895 - Action field added to GLBITHPD (Recompiled)        *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG6008 - Block acceptance if a TI batch has at least one    *
      *            invalid posting.                                   *
      *  BUG5821 - Need to initialise BTNBINS else possible to get    *
      *            a batch number of 000                              *
      *  CSC024 - Open Month End                                      *
      *  BUG3546 - Do not allow branch change if single branch batch  *
      *            and items already exist for different branch       *
      *  BUG3899 - Allow multi branch batches to be accepted          *
      *  BUG2948 - Do not allow change of Multi-branch field from     *
      *            'Y' to 'N'.                                        *
      *  BUG711 - Recompiled due to change in GLBITHPD                *
      *  CAP084 - MidasPlus Changes                                   *
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
      ** JE Summary file                                                        CAP084
     FGLJENSL1  IF   E           K DISK    INFSR(*PSSR)                         CAP084
      *                                                                         CAP084
     FGLBTNOL0  IF   E           K DISK    INFSR(*PSSR)                         CAP084
      *                                                                         CAP084
      ** JE Items file                                                                       BUG3546
     FGLJENPL1  IF   E           K DISK    INFSR(*PSSR)                                      BUG3546
      *                                                                                      BUG3546
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,GLBITHV001
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
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
     D Javauser        S              1A                                                      243860
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      *                                                                                       CGL130
      ** Valid Characters                                                                     CGL130
      *                                                                                       CGL130
     D #VLDVL          C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ012-              CGL130
     D                                     3456789')                                          CGL130
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Transaction (DS)
     D PTranIn       E DS                  EXTNAME(GLBITHPD)
      *
      ** Valid JE Header (DS) - for file update
     D PVBITH        E DS                  EXTNAME(GLVBITHPD)
                                                                                             BUG2948
      ** Current JE Header (DS)                                                              BUG2948
     D CurFilJENH    E DS                  EXTNAME(GLJENHPD)                                 BUG2948
     D                                     PREFIX(H_)                                        BUG2948
      *
      ** JE Headers Error Indicators (DS)
     D PFlagsOK      E DS                  EXTNAME(GLEBITHPD)
      *
      ** JE Headers Extra Data (DS)
     D PExtData      E DS                  EXTNAME(GLBHEXPD)
      *
      ** DS for User Branch Code
     D ZMUSER          DS            17
     D  WUSRID                 1     10                                                       CAP084
     D  WBrch                 11     13
     D  WDppt                 14     17                                                       240080
      *                                                                                       CAP084
      ** DS for Batch Number                                                                  CAP084
     D BTNBZZ          DS             3                                                       CAP084
     D  BTNBZ1                 1      1                                                       CAP084
     D  BTNBZ2                 2      2                                                       CAP084
     D  BTNBZ3                 3      3                                                       CAP084
      *
      ** External DS for SAR Details                                                          CSC024
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC024
                                                                                              CSC024
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC024
      *                                                                                       248749
      ** Externally described DS for Account Code details                                     248749
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  248749
      *                                                                                       248749
      ** DS for Access Programs - long data structure                                         248749
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     248749
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIdx            S              3P 0
                                                                                              CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D P@RTCD          S              7A                                                      CSC024
     D P@OPTN          S              7A                                                      CSC024
     D P@SARD          S              6A                                                      CSC024
                                                                                              CSC024
     D PRetCode        S              7A                                                      CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                                      CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
     D/COPY WNCPYSRC,GLH00448
      *                                                                                       CER046
     D CER046          S              1A                                                      CER046
     D CGL182          S              1A                                                      CGL182
                                                                                            MD054696
      ** JE Headers Shadow Post Indicator                                                   MD054696
     D DDSHPI          S              1A                                                    MD054696
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,GLBITHV002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
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
      ** Get default branch of user.                                                         BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      **********                                                                      BUG8550 243860
     C*****WUSRID        IFNE      *BLANKS                                            BUG8550 243860
     C*****WUSRID        ANDNE     PSUser                                             BUG8550 243860
     C**********         MOVE      'Y'           JAVAUSER          1                  BUG8550 243860
     C**********         ELSE                                                         BUG8550 243860
     C**********         MOVE      'N'           JAVAUSER                             BUG8550 243860
     C**********         ENDIF                                                        BUG8550 243860
     C                   if        fromJava='Y'                                               243860
     C                   eval      javauser='Y'                                               243860
     C                   else                                                                 243860
     C                   eval      javauser='N'                                               243860
     C                   endif                                                                243860
                                                                                             BUG8550
      /COPY WNCPYSRC,GLBITHV003
                                                                                              CAP084
      ** Do not want 'I' to go back as the value of DDBHAI if there are other errors          CAP084
      ** If DDBHAI was 'I' and batch number is not blanks then user has entered a             CAP084
      ** batch number so set a flag to indicate this.                                         CAP084
                                                                                              CAP084
     C                   Eval      BTNBINS = *Blanks                                         BUG5821
     C     DDBHAI        IFEQ      'I'                                                        CAP084
     C     JAVAUSER      ANDEQ     'Y'                                                        CAP084
     C                   EVAL      DDBHAI = 'H'                                               CAP084
     C     DDBTNB        IFNE      *BLANKS                                                    CAP084
     C                   MOVE      'Y'           BTNBINS           1                          CAP084
     C                   ENDIF                                                                CAP084
     C                   ENDIF                                                                CAP084
 
      ** If system is multi-branching, validate Branch Code.
      ** Else, default Branch Code to Bank's Single Branch Code.
 
      /COPY WNCPYSRC,GLBITHV004
 
     C     BJSBRC        IFEQ      *BLANKS
      * Amend mode                                                                           BUG3546
     C     JAVAUSER      IFEQ      'Y'                                                       BUG3546
     C     DDBTNB        ANDNE     *BLANKS                                                   BUG3546
     C     BTNBINS       ANDNE     'Y'                                                       BUG3546
     C     H_BRMBRB      ANDNE     'Y'                                                       BUG3546
     C     DDMBRB        ANDNE     'Y'                                                       BUG3546
     C     DDBCDA        ANDNE     H_BRBCDA                                                  BUG3546
     C                   EXSR      CHGBRCH                                                   BUG3546
     C                   ENDIF                                                               BUG3546
      *                                                                                      BUG3546
     C                   EXSR      SRBRCD
     C                   ELSE
     C                   EVAL      B1BCDA = BJSBRC
     C**********         EVAL      DDBCDA = *BLANKS                                           246752
     C                   EVAL      DDBCDA = BJSBRC                                            246752
     C                   ENDIF
 
      /COPY WNCPYSRC,GLBITHV005
 
      ** Validate Department Code.
 
      /COPY WNCPYSRC,GLBITHV006
 
     C                   EXSR      SRDPCD
 
      /COPY WNCPYSRC,GLBITHV007
 
      ** If system is multi-branching, validate Multiple
      ** Branch Batch Indicator.  Else, default Multiple
      ** Branch Batch Indicator to 'N'.
 
      /COPY WNCPYSRC,GLBITHV008
 
     C     BJSBRC        IFEQ      *BLANKS
     C                   EXSR      SRMBRB
     C                   ELSE
     C                   EVAL      B1MBRB = 'N'
     C**********         EVAL      DDMBRB = *BLANKS                                           246752
     C                   EVAL      DDMBRB = 'N'                                               246752
     C                   ENDIF
 
      /COPY WNCPYSRC,GLBITHV009
 
      ** Validate Batch Description.
 
      /COPY WNCPYSRC,GLBITHV010
 
     C                   EXSR      SRBDES
 
      /COPY WNCPYSRC,GLBITHV011
 
      ** Validate Batch Total.
 
      /COPY WNCPYSRC,GLBITHV012
 
     C                   EXSR      SRBTOT
 
      /COPY WNCPYSRC,GLBITHV013
 
      ** Validate No. of Items.
 
      /COPY WNCPYSRC,GLBITHV014
 
     C                   EXSR      SRNOIS
 
      ***Validate*Month*End*Adjustment*Batch                                           CSC024 CSC054
      ** Validate Period End Adjustments Batch                                                CSC054
                                                                                              CSC024
     C*********          EXSR      SRMEAB                                              CSC024 CSC054
     C                   EXSR      SRPEAB                                                     CSC054
                                                                                              CSC024
      ** Validate Shadow Post Indicator field                                               MD054696
                                                                                            MD054696
     C                   EXSR      SRSHPI                                                   MD054696
                                                                                            MD054696
      /COPY WNCPYSRC,GLBITHV015
 
      ** Validate Batch Held/Accepted Indicator.
 
      /COPY WNCPYSRC,GLBITHV016
 
      ** If coming from a java user then allow held/accept indicator to be 'D'                CAP084
      ** so that the batch header can be deleted.                                             CAP084
                                                                                              CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     DDBHAI        ANDEQ     'D'                                                        CAP084
     C     CGL182        OREQ      'Y'                                                        CGL182
     C     DDBHAI        ANDEQ     'P'                                                        CGL182
     C                   EVAL      B1BHAI = DDBHAI                                            CAP084
     C                   ELSE                                                                 CAP084
     C                   EXSR      SRBHAI
     C                   ENDIF                                                                CAP084
      *                                                                                     BUG12820
      ** Remove blanks from the field                                                       BUG12820
      *                                                                                     BUG12820
     C     DDBTNB        IFNE      *BLANKS                                                  BUG12820
     C                   MOVE      DDBTNB        BTNBZZ                                     BUG12820
     C     BTNBZ3        DOWEQ     *BLANKS                                                  BUG12820
     C                   MOVE      BTNBZ2        BTNBZ3                                     BUG12820
     C                   MOVE      BTNBZ1        BTNBZ2                                     BUG12820
     C                   MOVE      '0'           BTNBZ1                                     BUG12820
     C                   ENDDO                                                              BUG12820
     C                   MOVE      BTNBZZ        DDBTNB                                     BUG12820
     C                   ENDIF                                                              BUG12820
      *                                                                                       240107
      **  If the Transaction Number is zero                                                   240107
      *                                                                                       240107
     C                   If        DDBTNB = *ZEROS                                            240107
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                                240107
     C**********         MOVEL     'GLX0168'     MsgIdArr(1)                         240107 BUG13869
     C                   MOVEL     'GLX0429'     MsgIdArr(1)                                BUG13869
     C                   EXSR      SRUPDERR                                                   240107
     C                   ENDIF                                                                240107
      *                                                                                       240107
      **  If the Transaction Number is not blank, check that it is numeric.                   240107
      *                                                                                       240107
     C/COPY WNCPYSRC,GLH00050
      *                                                                                       CGL130
      ** If CGL130 is on                                                                      CGL130
      *                                                                                       CGL130
     C                   IF        CGL130 = 'Y'                                               CGL130
     C                   IF        FOTRID <> *BLANKS AND                                   AR1078953
     C                             DDBTNB =  *BLANKS                                       AR1078953
      ** Allow blank batch number if from 3rd party                                        AR1078953
     C                   ELSE                                                              AR1078953
      ** Validate batch number                                                             AR1078953
     C                   IF        DDBTNB = '000'                                             CGL130
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                                CGL130
     C**********         MOVEL     'GLX0431'     MsgIdArr(1)                        CGL130 AR1070246
     C                   MOVEL     '5045865'     MsgIdArr(1)                               AR1070246
     C                   EXSR      SRUPDERR                                                   CGL130
     C                   ELSE                                                                 CGL130
      *                                                                                       CGL130
      ** Check if batch number is alpha numeric                                               CGL130
      *                                                                                       CGL130
     C                   MOVE      'Y'           #OK               1                          CGL130
     C                   Z-ADD     1             #X                1 0                        CGL130
     C                   DOW       (#OK = 'Y') AND (#X < 4)                                   CGL130
      *                                                                                       CGL130
      ** Check for valid values                                                               CGL130
      *                                                                                       CGL130
     C     1             SUBST     DDBTNB:#X     #CH               1                          CGL130
     C     #CH           SCAN      #VLDVL:1      #P                2 0    50                  CGL130
     C                   IF        *IN50 = *OFF                                               CGL130
     C                   MOVE      'N'           #OK                                          CGL130
     C                   ENDIF                                                                CGL130
     C                   ADD       1             #X                                           CGL130
     C                   ENDDO                                                                CGL130
      *                                                                                       CGL130
      ** Send error message if one of the characters is not valid                             CGL130
      *                                                                                       CGL130
     C                   IF        #OK = 'N'                                                  CGL130
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                                CGL130
     C**********         MOVEL     'GLX0431'     MsgIdArr(1)                        CGL130 AR1070246
     C                   MOVEL     '5045865'     MsgIdArr(1)                               AR1070246
     C                   EXSR      SRUPDERR                                                   CGL130
     C                   ENDIF                                                                CGL130
     C                   ENDIF                                                                CGL130
     C                   ENDIF                                                             AR1078953
     C                   ELSE                                                                 CGL130
     C                   TESTN                   DDBTNB               98                      240107
     C                   MOVE      DDBTNB        @1BTNB            1                          240107
     C                   TESTZ                   @1BTNB                   99                  240107
     C                   IF        DDBTNB <> *BLANKS AND                                      240107
     C                             *IN98 = *OFF OR                                            240107
     C                             DDBTNB <> *BLANKS AND                                      240107
     C                             *IN99 = *OFF                                               240107
     C                   MOVEL     'DDBTNB'      FldNameArr(1)                                240107
     C**********         MOVEL     'GLX0168'     MsgIdArr(1)                         240107 BUG13869
     C                   MOVEL     'GLX0429'     MsgIdArr(1)                                BUG13869
     C                   EXSR      SRUPDERR                                                   240107
     C                   ENDIF                                                                240107
     C                   ENDIF                                                                CGL130
     C/COPY WNCPYSRC,GLH00051
      **********                                                                     239608 BUG13181
      ***If*the*Transaction*Number*is*zero*or*blank.                                 239608 BUG13181
      **********                                                                     239608 BUG13181
     C**********         IF        DDBTNB = *BLANKS OR                               239608 BUG13181
     C**********                   DDBTNB = *ZEROS                                   239608 BUG13181
     C**********         MOVEL     'DDBTNB'      FldNameArr(1)                       239608 BUG13181
     C**********         MOVEL     'USR4312'     MsgIdArr(1)                         239608 BUG13181
     C**********         EXSR      SRUPDERR                                          239608 BUG13181
     C**********         ENDIF                                                       239608 BUG13181
      **********                                                                     239608 BUG13181
      ***If*the*Transaction*Number*is*not*blank,*check*that*it*is*numeric.  239608 BUG11734 BUG13181
      **********                                                            239608 BUG11734 BUG13181
     C**********         TESTN                   DDBTNB               98    239608 BUG11734 BUG13181
     C**********         MOVE      DDBTNB        @1BTNB            1        239608 BUG11734 BUG13181
     C**********         TESTZ                   @1BTNB                   99239608 BUG11734 BUG13181
     C**********         IF        DDBTNB <> *BLANKS AND                    239608 BUG11734 BUG13181
     C**********                   *IN98 = *OFF OR                          239608 BUG11734 BUG13181
     C**********                   DDBTNB <> *BLANKS AND                    239608 BUG11734 BUG13181
     C**********                   *IN99 = *OFF                             239608 BUG11734 BUG13181
     C**********         MOVEL     'DDBTNB'      FldNameArr(1)              239608 BUG11734 BUG13181
     C**********         MOVEL     'GLX0168'     MsgIdArr(1)                239608 BUG11734 BUG13181
     C**********         EXSR      SRUPDERR                                 239608 BUG11734 BUG13181
     C**********         ENDIF                                              239608 BUG11734 BUG13181
                                                                                              CAP084
     C/COPY WNCPYSRC,GLH00449
      ** Set up Batch Header Number if not an insert                                          CAP084
                                                                                              CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     DDBTNB        ANDNE     *BLANKS                                                    CAP084
     C     BTNBINS       ANDNE     'Y'                                                        CAP084
     C                   MOVE      DDBTNB        B1BTNB                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
      ** If user has inserted a batch number when inserting a header then we                  CAP084
      ** need to check whether this number has already been used                              CAP084
      *                                                                                       CAP084
     C     BTNBINS       IFEQ      'Y'                                                        CAP084
     C*****CSC024        OREQ      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ANDEQ     'Y'                                                        CSC054
     C*****CSC054        OREQ      'Y'                                               CSC054 AR996631
     C*****WPEAInd       ANDEQ     'Y'                                               CSC054 AR996631
     C*****DDBHAI        ANDEQ     'H'                                               CSC024 AR996631
     C*****DDBTNB        ANDNE     *BLANKS                                           CSC024 AR996631
      *                                                                                       CAP084
      ** Remove blanks from the field                                                         CAP084
     C                   MOVE      DDBTNB        BTNBZZ                                       CAP084
     C     BTNBZ3        DOWEQ     *BLANKS                                                    CAP084
     C                   MOVE      BTNBZ2        BTNBZ3                                       CAP084
     C                   MOVE      BTNBZ1        BTNBZ2                                       CAP084
     C                   MOVE      '0'           BTNBZ1                                       CAP084
     C                   ENDDO                                                                CAP084
     C                   MOVE      BTNBZZ        DDBTNB                                       CAP084
      *                                                                                       CAP084
     C     DDBTNB        CHAIN     GLBTNOL0                           02                      CAP084
      *                                                                                       CAP084
      ** A record already exists with this batch number, send an error message                CAP084
      *                                                                                       CAP084
     C     *IN02         IFEQ      *OFF                                                       CAP084
     C**********         MOVEL     'DDBTNB'      FldNamXAr(1)                         CAP084 241505A
     C**********         MOVEL     'GLX0421'     MsgIdXAr(1)                          CAP084 241505A
     C                   ADD       1             Idx                                         241505A
     C                   MOVEL     'DDBTNB'      FldNamXAr(Idx)                              241505A
     C                   MOVEL     'GLX0421'     MsgIdXAr(Idx)                               241505A
     C                   EXSR      SRUPDERR                                                   CAP084
     C                   ELSE                                                                 CAP084
     C                   MOVE      *OFF          *IN02                                        CAP084
      *                                                                                       CAP084
     C                   MOVE      DDBTNB        B1BTNB                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
      ** If batch has been requested to be accepted then check currency totals and if the     CAP084
      ** batch is valid then change status to Accepted.                                       CAP084
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     DDBHAI        ANDEQ     'A'                                                        CAP804
     C     DDBTNB        ANDNE     *BLANKS                                                    CAP084
     C                   EXSR      SRRESET                                                    CAP084
     C                   EXSR      SRChkCcy                                                   CAP084
     C                   EXSR      SRChkdet                                                   241505
     C                   EXSR      SRValAccd                                                  248749
      *                                                                                      BUG6008
      ** If a TI originated batch check that every posting has Valid = 'Y'.                  BUG6008
      *                                                                                      BUG6008
     C     H_BRBDES      IFEQ      TRADINOV                                                  BUG6008
     C     H_BRBDES      OREQ      TRADINUS                                                  BUG6008
      *                                                                                       CER046
      ** Process the non TI batch number only when CER046 is ON                               CER046
      *                                                                                       CER046
     C     CER046        OREQ      'Y'                                                        CER046
     C                   EXSR      SRVALID                                                   BUG6008
     C                   ENDIF                                                               BUG6008
     C**********         EXSR      SRUPDERR                                            CAP084 248749
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP804
      /COPY WNCPYSRC,GLBITHV017
 
      ** If invalid Branch Code, default Branch to User Branch
      ** Code to enable the batch to be corrected through the
      ** existing maintenance.
 
     C     DDBcdaOK      IFEQ      'N'
     C                   EVAL      B1BCDA = WBrch
     C                   ENDIF
 
      /COPY WNCPYSRC,GLBITHV018
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,GLBITHV019
      *
      *****************************************************************                      BUG3546
      /EJECT                                                                                 BUG3546
      *****************************************************************                      BUG3546
      *                                                               *                      BUG3546
      *  CHGBRCH  - Validate change of branch                         *                      BUG3546
      *                                                               *                      BUG3546
      *****************************************************************                      BUG3546
      *                                                                                      BUG3546
     C     CHGBRCH       BEGSR                                                               BUG3546
      *                                                                                      BUG3546
      ** Reset error fields.                                                                 BUG3546
      *                                                                                      BUG3546
     C                   EXSR      SRRESET                                                   BUG3546
      *                                                                                      BUG3546
     C     H_BRBTNB      CHAIN(N)  @BTREAL                            90                     BUG3546
     C     *IN90         IFEQ      *OFF                                                      BUG3546
     C**********         MOVEL     'DDBCDA'      FldNamXAr(1)                        BUG3546 241505A
     C**********         MOVEL     'GLX004B'     MsgIdXAr(1)                         BUG3546 241505A
     C                   ADD       1             Idx                                         241505A
     C                   MOVEL     'DDBCDA'      FldNamXAr(Idx)                              241505A
     C                   MOVEL     'GLX004B'     MsgIdXAr(Idx)                               241505A
     C                   EXSR      SRUPDERR                                                  BUG3546
     C                   ENDIF                                                               BUG3546
      *                                                                                      BUG3546
     C                   ENDSR                                                               BUG3546
      *                                                                                      BUG3546
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRCD - Validate Branch Code                                *
      *                                                               *
      *****************************************************************
      *
     C     SRBRCD        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVBHCD02'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Branch Code
     C                   PARM                    DDBCDA
     C                   PARM                    WBrch                                        240080
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Branch Code - OK indicator
     C                   PARM                    DDBcdaOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDPCD - Validate Department Code                            *
      *                                                               *
      *****************************************************************
      *
     C     SRDPCD        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVDOCD'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Department Code
     C                   PARM                    DDDPCD
     C                   PARM                    WDppt                                        240080
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Department Code - OK indicator
     C                   PARM                    DDDpcdOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMBRB - Validate Multiple Branch Batch Indicator            *
      *                                                               *
      *****************************************************************
      *
     C     SRMBRB        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVBRIN'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Multibranch Batch Indicator
     C                   PARM                    DDMBRB
                                                                                             BUG2948
      ** Multibranch Batch Indicator on File                                                 BUG2948
     C                   PARM                    H_BRMBRB                                    BUG2948
      *
      ** Action Code of Transaction                                                         AR850162
     C                   PARM                    DDACTN                                     AR850162
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Multibranch Batch Indicator - OK  indicator
     C                   PARM                    DDMbrbOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBDES - Validate Batch Description                          *
      *                                                               *
      *****************************************************************
      *
     C     SRBDES        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVBCDX'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Batch Description
     C                   PARM                    DDBDES
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Batch Description - OK indicator
     C                   PARM                    DDBdesOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBTOT - Validate Batch Total                                *
      *                                                               *
      *****************************************************************
      *
     C     SRBTOT        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVBCTO'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Batch Total
     C                   PARM                    DDFMAM
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Mandatory Batch No./ No. of Items
     C                   PARM                    BKMHTN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Batch Total - OK indicator
     C                   PARM                    DDFmamOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOIS - Validate No. of Items                               *
      *                                                               *
      *****************************************************************
      *
     C     SRNOIS        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVNBIM02'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                                       237512
      ** GL ICD Setup                                                                         237512
     C                   PARM                    BKMHTN                                       237512
      *
      ** No. of items
     C                   PARM                    DDNOIS
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** No. of items - OK indicator
     C                   PARM                    DDNoisOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *
      *****************************************************************                       CSC024
      /EJECT                                                                                  CSC024
      *****************************************************************                       CSC024
      *                                                               *                       CSC024
      ***SRMEAB*-*Validate*Month*End*Adjustment*Batch                 *                CSC024 CSC054
      *  SRPEAB - Validate Period End Adjustments Batch               *                       CSC054
      *                                                               *                       CSC024
      *****************************************************************                       CSC024
      *                                                                                       CSC024
     C*****SRMEAB        BEGSR                                                         CSC024 CSC054
     C     SRPEAB        BEGSR                                                                CSC054
                                                                                              CSC024
      ** Reset error fields.                                                                  CSC024
     C                   EXSR      SRRESET                                                    CSC024
      *                                                                                       CSC024
     C                   CALLB     'GLVMEAB'                                                  CSC024
      *                             =========                                                 CSC024
      ** INPUT                                                                                CSC024
      ** =====                                                                                CSC024
      *                                                                                       CSC024
      ** Return Code                                                                          CSC024
     C                   PARM                    RetCodeOut                                   CSC024
      *                                                                                       CSC024
      ** No. of items                                                                         CSC024
     C                   PARM                    DDMEAB                                       CSC024
      *                                                                                       CSC024
      ** OUTPUT                                                                               CSC024
      ** ======                                                                               CSC024
      *                                                                                       CSC024
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSC024
     C                   PARM                    FldNamXAr                                    CSC024
     C                   PARM                    MsgIDXAr                                     CSC024
     C                   PARM                    MsgDtaXAr                                    CSC024
      *                                                                                       CSC024
      ** No. of items - OK indicator                                                          CSC024
     C                   PARM                    DDNoisOK                                     CSC024
      *                                                                                       CSC024
      ** Valid JE Header (DS) - for file update                                               CSC024
     C                   PARM                    PVBITH                                       CSC024
      *                                                                                       CSC024
      ** Update error information.                                                            CSC024
      *                                                                                       CSC024
     C                   EXSR      SRUPDERR                                                   CSC024
      *                                                                                       CSC024
     C                   ENDSR                                                                CSC024
      *                                                                                       CSC024
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBHAI - Validate Batch Held/Accepted Indicator              *
      *                                                               *
      *****************************************************************
      *
     C     SRBHAI        BEGSR
      *
      ** Reset error fields.
      *
     C                   EXSR      SRRESET
      *
     C                   CALLB     'GLVBCIN'
      *                             =======
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Batch Held/Accepted Indicator
     C                   PARM                    DDBHAI
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Batch Held/Accepted Indicator - OK indicator
     C                   PARM                    DDBhaiOK
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
      *
      ** Update error information.
      *
     C                   EXSR      SRUPDERR
      *
     C                   ENDSR
      *****************************************************************                       CAP804
      /EJECT                                                                                  CAP084
      *****************************************************************                       CAP084
      *                                                               *                       CAP084
      *  SRChkCcy - Check Currency Totals for accepting the batch     *                       CAP804
      *                                                               *                       CAP084
      *****************************************************************                       CAP084
      *                                                                                       CAP084
     C     SRChkCcy      BEGSR                                                                CAP804
      *                                                                                       CAP084
      ** Position currency file in batch number.                                              CAP084
      *                                                                                       CAP084
     C                   MOVE      'Y'           WCcyBal           1                          CAP084
     C     B1BTNB        SETLL     GLJENSL1                                                   CAP804
     C     B1BTNB        READE     GLJENSL1                               01                  CAP084
      *                                                                                       CAP084
     C     *IN01         IFEQ      *ON                                                        CAP084
     C                   MOVE      'N'           WCcyBal                                      CAP804
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     ** Check if currency DR and CR totals balance.                                           CAP804
      *                                                                                       CAP084
     C     B1MBRB        IFNE      'Y'                                                       BUG3899
     C     *IN01         DOWEQ     *OFF                                                       CAP084
     C     WCcyBal       ANDEQ     'Y'                                                        CAP084
      *                                                                                       CAP804
     C     BSDBTT        IFNE      BSCRTT                                                     CAP084
     C                   MOVE      'N'           WCcyBal                                      CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP804
     C     B1BTNB        READE     GLJENSL1                               01                  CAP084
     C                   ENDDO                                                                CAP084
      *                                                                                      BUG3899
     C                   ELSE                                                                BUG3899
      * Multi branch batch - check each ccy total for all branches matches                   BUG3899
     C                   Z-ADD     0             WDBTT            15 0                       BUG3899
     C                   Z-ADD     0             WCRTT            15 0                       BUG3899
     C                   MOVE      BSCYCD        WCYCD             3                         BUG3899
     C     *IN01         DOWEQ     *OFF                                                      BUG3899
     C     WCcyBal       ANDEQ     'Y'                                                       BUG3899
     C     WCYCD         IFNE      BSCYCD                                                    BUG3899
     C     WDBTT         IFNE      WCRTT                                                     BUG3899
     C                   Eval      WccyBal = 'N'                                             BUG3899
     C                   ENDIF                                                               BUG3899
     C                   Z-ADD     0             WDBTT                                       BUG3899
     C                   Z-ADD     0             WCRTT                                       BUG3899
     C                   ENDIF                                                               BUG3899
     C                   ADD       BSDBTT        WDBTT                                       BUG3899
     C                   ADD       BSCRTT        WCRTT                                       BUG3899
     C                   Eval      WCYCD = BSCYCD                                            BUG3899
     C     B1BTNB        READE     GLJENSL1                               01                 BUG3899
     C                   ENDDO                                                               BUG3899
     C     WDBTT         IFNE      WCRTT                                                     BUG3899
     C     WCcyBal       ANDNE     'N'                                                       BUG3899
     C                   Eval      WCcyBal = 'N'                                             BUG3899
     C                   ENDIF                                                               BUG3899
     C                   ENDIF                                                               BUG3899
      *                                                                                       CAP084
      ** If currency totals balance check if Batch Status flag can be changed                 CAP804
      ** from 'H' to 'A' and set up message if batch cannot be accepted yet                   CAP084
      *                                                                                       CAP084
     C     WCcyBal       IFEQ      'Y'                                                        CAP804
      *                                                                                       CAP084
      ** Batch Status is set to 'A' only if Multiple Branch                                   CAP084
      ** Batch is 'Y' or Branch Code is equal to Input Branch Code                            CAP804
      *                                                                                       CAP084
      *                                                                                       CAP084
     C     B1MBRB        IFEQ      'Y'                                                        CAP084
     C     B1BCDA        OREQ      DDBCDA                                                     CAP804
     C                   MOVE      'A'           B1BTSF                                       CAP084
     C                   ENDIF                                                                CAP804
     C                   ELSE                                                                 CAP084
     C**********         MOVEL     'DDBHAI'      FldNamXAr(1)                         CAP084 241505A
     C**********         MOVEL     'GLX0075'     MsgIdXAr(1)                          CAP084 241505A
     C                   ADD       1             Idx                                         241505A
     C                   MOVEL     'DDBHAI'      FldNamXAr(Idx)                              241505A
     C                   MOVEL     'GLX0075'     MsgIdXAr(Idx)                               241505A
     C                   MOVE      'N'           DDBHAIOK                                     CAP084
     C                   EXSR      SRUPDERR                                                   248749
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDSR                                                                CAP084
      *
      *****************************************************************
      /EJECT                                                                                  241505
      *****************************************************************                       241505
      *                                                               *                       241505
      *  SRChkdet - Check GLJENPPD for invalid batch details.         *                       241505
      *                                                               *                       241505
      *****************************************************************                       241505
      *                                                                                       241505
     C     SRChkdet      BEGSR                                                                241505
      *                                                                                       241505
      ** Position currency file in batch number.                                              241505
      *                                                                                       241505
     C                   MOVE      'Y'           WBtchdt           1                          241505
     C                   MOVE      '0'           *IN03                                        241505
      *                                                                                       241505
     C     B1BTNB        SETLL     @BTREAL                            99                      241505
      *                                                                                       241505
     C     *IN99         IFEQ      *OFF                                                       241505
     C     B1BTNB        READE     @BTREAL                                03                  241505
      *                                                                                       241505
     C     *IN03         DOWEQ     *OFF                                                       241505
     C     WBtchdt       ANDNE     'N'                                                        241505
      *                                                                                       241505
     C     BTVALI        IFNE      'Y'                                                        241505
     C                   MOVE      '1'           *IN03                                        241505
     C                   MOVE      'N'           WBtchdt           1                          241505
     C                   ENDIF                                                                241505
      *                                                                                       241505
     C     B1BTNB        READE     @BTREAL                                03                  241505
      *                                                                                       241505
     C     WBtchdt       IFEQ      'N'                                                        241505
     C                   EXSR      SRRESET                                                    248749
     C**********         MOVEL     'DDBTNB'      FldNamXAr(2)                         241505 241505A
     C**********         MOVEL     'GLX0428'     MsgIdXAr(2)                          241505 241505A
     C                   ADD       1             Idx                                         241505A
     C                   MOVEL     'DDBTNB'      FldNamXAr(Idx)                              241505A
     C                   MOVEL     'GLX0428'     MsgIdXAr(Idx)                               241505A
     C                   MOVE      'N'           DDBHAIOK                                     241505
     C                   EXSR      SRUPDERR                                                   248749
     C                   ENDIF                                                                241505
     C                   ENDDO                                                                241505
     C                   ENDIF                                                                241505
      *                                                                                       241505
     C                   SETOFF                                       0399                    241505
      *                                                                                       241505
     C                   ENDSR                                                                241505
      *****************************************************************                       241505
      /EJECT
      *****************************************************************                      BUG6008
      *                                                               *                      BUG6008
      *  SRVALID - For TI originated batch check all postings are     *                      BUG6008
      *            valid.                                             *                      BUG6008
      *                                                               *                      BUG6008
      *****************************************************************                      BUG6008
      *                                                                                      BUG6008
     C     SRVALID       BEGSR                                                               BUG6008
      *                                                                                      BUG6008
      * If batch has come from TI and is held then need to correct invalid postings          BUG6008
      * before the batch can be accepted.                                                    BUG6008
      *                                                                                      BUG6008
     C                   SETOFF                                       20                     BUG6008
      *                                                                                      BUG6008
     C     H_BRBTNB      SETLL     @BTREAL                            99                     BUG6008
     C     *IN99         IFEQ      *OFF                                         B01          BUG6008
     C     H_BRBTNB      READE     @BTREAL                                98                 BUG6008
      *                                                                                      BUG6008
     C     *IN98         DOWEQ     *OFF                                         B02          BUG6008
      *                                                                                      BUG6008
     C     BTVALI        IFEQ      'N'                                          B03          BUG6008
     C                   SETON                                        20                     BUG6008
     C                   ENDIF                                                  E03          BUG6008
      *                                                                                      BUG6008
     C     H_BRBTNB      READE     @BTREAL                                98                 BUG6008
     C                   ENDDO                                                  E02          BUG6008
      *                                                                                      BUG6008
     C                   SETOFF                                       9899                   BUG6008
     C     *IN20         IFEQ      *ON                                          B02          BUG6008
     C                   EXSR      SRRESET                                                    248749
     C                   ADD       1             Idx                                         241505A
     C**********         MOVEL     'DDBHAI'      FldNamXAr(1)                        BUG6008 241505A
     C                   MOVEL     'DDBHAI'      FldNamXAr(Idx)                              241505A
      *                                                                                       CER046
     C                   IF        H_BRBDES = TRADINOV OR                                     CER046
     C                             H_BRBDES = TRADINUS                                        CER046
      *                                                                                       CER046
     C**********         MOVEL     'GLX0426'     MsgIdXAr(1)                         BUG6008 241505A
     C                   MOVEL     'GLX0426'     MsgIdXAr(Idx)                               241505A
      *                                                                                       CER046
     C                   ELSE                                                                 CER046
     C                   MOVEL     'GLU0022'     MsgIdXAr(Idx)                                CER046
     C                   ENDIF                                                                CER046
      *                                                                                       CER046
     C                   MOVE      'N'           DDBHAIOK                                    BUG6008
     C                   EXSR      SRUPDERR                                                   248749
     C                   ENDIF                                                  E02          BUG6008
      *                                                                                      BUG6008
     C                   ENDIF                                                  E01          BUG6008
      *                                                                                      BUG6008
     C                   ENDSR                                                               BUG6008
      *                                                                                      BUG6008
      *****************************************************************                      BUG6008
      /EJECT                                                                                 BUG6008
      *****************************************************************
      *                                                               *
      *  SRRESET - Reset error information that is received back from *
      *            each validation module                             *
      *                                                               *
      *****************************************************************
      *
     C     SRRESET       BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   MOVEL     *BLANKS       FldNamXAr
     C                   MOVEL     *BLANKS       MsgIDXAr
     C                   MOVEL     *BLANKS       MsgDtaXAr
      *
     C                   MOVEL     *BLANKS       WFldNmXAr
     C                   MOVEL     *BLANKS       WMsgIDXAr
     C                   MOVEL     *BLANKS       WMsgDtXAr
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDERR - Routine to update Error Information with that     *
      *             received back from each validation module         *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDERR      BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C     *IN01         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C     *IN01         IFEQ      '1'
     C     I             SUB       1             Idx
     C                   ELSE
     C                   EVAL      I = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(I)
     C                   MOVE      *BLANKS       MSGIDARR(I)
     C                   MOVE      *BLANKS       MSGDTAARR(I)
     C                   EVAL      Idx = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C     *IN01         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C     *IN01         IFEQ      '1'
     C     I             SUB       1             WIdx
     C                   ELSE
     C                   EVAL      I = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(I)
     C                   MOVE      *BLANKS       WMSGIDARR(I)
     C                   MOVE      *BLANKS       WMSGDTAARR(I)
     C                   EVAL      WIdx = ArrayMax - 1
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       248749
      *                                                               *                       248749
      *  SRValAccd - Validate Account Code                            *                       248749
      *                                                               *                       248749
      *****************************************************************                       248749
      *                                                                                       248749
     C     SRValAccd     BEGSR                                                                248749
      *                                                                                       248749
     C     B1BTNB        SETLL     GLJENPL1                                                   248749
     C     B1BTNB        READE     GLJENPL1                               01                  248749
     C                   DOW       *IN01 = *OFF                                               248749
      *                                                                                       248749
     C                   CALL      'AOACODR0'                                                 248749
     C                   PARM      *BLANKS       PRTCD             7                          248749
     C                   PARM      '*KEY   '     POPTN             7                          248749
     C                   PARM      BTACCD        PKACOD           10                          248749
     C     SDACOD        PARM      SDACOD        DSSDY                                        248749
      *                                                                                       248749
     C     PRTCD         IFNE      *BLANKS                                                    248749
     C                   EXSR      SRRESET                                                    248749
     C                   MOVEL     'BTACCD'      FldNamXAr(1)                                 248749
     C                   MOVEL     'GLX0149'     MsgIdXAr(1)                                  248749
     C                   MOVE      'N'           DDBHAIOK                                     248749
     C                   EXSR      SRUPDERR                                                   248749
     C                   ENDIF                                                                248749
      *                                                                                       248749
     C     B1BTNB        READE     GLJENPL1                               01                  248749
     C                   ENDDO                                                                248749
      *                                                                                       248749
     C                   ENDSR                                                                248749
      *                                                                                       248749
      *****************************************************************                     MD054696
      /EJECT                                                                                MD054696
      *****************************************************************                     MD054696
      *                                                               *                     MD054696
      *  SRSHPI - Validate Shadow Post Indicator                      *                     MD054696
      *                                                               *                     MD054696
      *****************************************************************                     MD054696
      *                                                                                     MD054696
     C     SRSHPI        BEGSR                                                              MD054696
      *                                                                                     MD054696
      ** Reset error fields.                                                                MD054696
      *                                                                                     MD054696
     C                   EXSR      SRRESET                                                  MD054696
      *                                                                                     MD054696
     C                   CALLB     'GLVSHPI'                                                MD054696
      *                             =======                                                 MD054696
      ** INPUT                                                                              MD054696
      ** =====                                                                              MD054696
      *                                                                                     MD054696
      ** Return Code                                                                        MD054696
     C                   PARM                    RetCodeOut                                 MD054696
      *                                                                                     MD054696
      ** Shadow Post Indicator                                                              MD054696
     C                   PARM                    DDSHPI                                     MD054696
      *                                                                                     MD054696
      ** OUTPUT                                                                             MD054696
      ** ======                                                                             MD054696
      *                                                                                     MD054696
      ** Error fields/message IDs/message data (arrays) from/to caller                      MD054696
     C                   PARM                    FldNamXAr                                  MD054696
     C                   PARM                    MsgIDXAr                                   MD054696
     C                   PARM                    MsgDtaXAr                                  MD054696
      *                                                                                     MD054696
      ** Shadow Post Ind - OK indicator                                                     MD054696
     C                   PARM                    DDSHPIOK                                   MD054696
      *                                                                                     MD054696
      ** Valid JE Header (DS) - for file update                                             MD054696
     C                   PARM                    PVBITH                                     MD054696
      *                                                                                     MD054696
      ** Update error information.                                                          MD054696
      *                                                                                     MD054696
     C                   EXSR      SRUPDERR                                                 MD054696
      *                                                                                     MD054696
     C                   ENDSR                                                              MD054696
      *****************************************************************                       248749
      /EJECT                                                                                  248749
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
      ** INPUT
      ** =====
      *
      ** Response Mode
     C**********         PARM                    APRESPMODE        1                          CAP084
     C                   PARM      'S'           APRESPMODE        1                          CAP084
      ** From Java only                                                                       243860
     C                   PARM                    fromJava          1                          243860
      *                                                                                    AR1078953
      * Front Office Transaction ID                                                        AR1078953
     C                   PARM                    FOTRID           20                       AR1078953
      *
      ** Incoming Transaction (DS)
     C                   PARM                    PTranIn
      *
      ** JE Headers Extra Data (DS)
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** SDGELR - Mandatory Batch No./ No. of Items
     C                   PARM                    BKMHTN            1
      *                                                                                     MD054696
      ** Batch Header - Shadow Post Indicator                                               MD054696
     C                   PARM                    DDSHPI                                     MD054696
      *
      ** OUTPUT
      ** ======
      *
      ** JE Headers Error Indicators (DS)
     C                   PARM                    PFlagsOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/msg data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** Valid JE Header (DS) - for file update
     C                   PARM                    PVBITH
                                                                                             BUG2948
      ** Current JE Header File Format                                                       BUG2948
     C                   PARM                    CurFilJENH                                  BUG2948
      *
      ** Get default branch of user.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
                                                                                              CAP084
     C*****WUSRID        IFNE      *BLANKS                                            CAP084 BUG8550
     C*****WUSRID        ANDNE     PSUser                                             CAP084 BUG8550
     C**********         MOVE      'Y'           JAVAUSER          1                  CAP084 BUG8550
     C**********         ELSE                                                         CAP084 BUG8550
     C**********         MOVE      'N'           JAVAUSER                             CAP084 BUG8550
     C**********         ENDIF                                                        CAP084 BUG8550
      *                                                                                      BUG6008
      ** Set TI batch comparison check fields.                                               BUG6008
      *                                                                                      BUG6008
     C                   MOVEL     'Trade Innova'TRADIN24         24                         BUG6008
     C                   MOVE      'tion        'TRADIN24                                    BUG6008
     C                   MOVEL     TRADIN24      TRADINOV         30                         BUG6008
      *                                                                                      BUG6008
     C                   MOVEL     'Batch in use'TRADIN24                                    BUG6008
     C                   MOVE      ' by TI      'TRADIN24                                    BUG6008
     C                   MOVEL     TRADIN24      TRADINUS         30                         BUG6008
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC024 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       P@RTCD                                       CSC024
     C                   PARM      '*VERIFY'     P@OPTN                                       CSC024
     C*********          PARM      'CSC024'      P@SARD                                CSC024 CSC054
     C                   PARM      'CSC054'      P@SARD                                       CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        P@RTCD <> *BLANKS  AND P@RTCD <> '*NRF   '                 CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 1                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
      *                                                                                       CER046
      ** Check if enhancement CER046 is on                                                    CER046
      *                                                                                       CER046
     C                   EVAL      CER046 = 'N'                                               CER046
      *                                                                                       CER046
     C                   CALLB     'AOSARDR0'                                                 CER046
     C                   PARM      *BLANKS       P@RTCD                                       CER046
     C                   PARM      '*VERIFY'     P@OPTN                                       CER046
     C                   PARM      'CER046'      P@SARD                                       CER046
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER046
      *                                                                                       CER046
     C                   IF        P@RTCD <> *BLANKS                                          CER046
     C                               AND P@RTCD <> '*NRF'                                     CER046
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER046
     C                   EVAL      DBKEY = 'CER046'                                           CER046
     C                   EVAL      DBASE = 3                                                  CER046
     C                   EXSR      *PSSR                                                      CER046
     C                   ENDIF                                                                CER046
      *                                                                                       CER046
     C                   IF        P@RTCD = *BLANKS                                           CER046
     C                   EVAL      CER046 = 'Y'                                               CER046
     C                   ENDIF                                                                CER046
      *                                                                                       CGL130
      ** Check if enhancement CGL130 is on                                                    CGL130
      *                                                                                       CGL130
     C                   MOVE      'N'           CGL130            1                          CGL130
      *                                                                                       CGL130
     C                   CALLB     'AOSARDR0'                                                 CGL130
     C                   PARM      *BLANKS       P@RTCD                                       CGL130
     C                   PARM      '*VERIFY'     P@OPTN                                       CGL130
     C                   PARM      'CGL130'      P@SARD            6                          CGL130
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL130
      *                                                                                       CGL130
     C                   IF        (P@RTCD <> *BLANKS) AND (P@RTCD <> '*NRF')                 CGL130
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL130
     C                   EVAL      DBKEY = 'CGL130'                                           CGL130
     C                   EVAL      DBASE = 4                                                  CGL130
     C                   EXSR      *PSSR                                                      CGL130
     C                   ENDIF                                                                CGL130
      *                                                                                       CGL130
     C                   IF        P@RTCD = *BLANKS                                           CGL130
     C                   EVAL      CGL130 = 'Y'                                               CGL130
     C                   ENDIF                                                                CGL130
      *                                                                                       CGL182
      ** Check if enhancement CGL182 is on                                                    CGL182
      *                                                                                       CGL182
     C                   MOVE      'N'           CGL182                                       CGL182
      *                                                                                       CGL182
     C                   CALLB     'AOSARDR0'                                                 CGL182
     C                   PARM      *BLANKS       P@RTCD                                       CGL182
     C                   PARM      '*VERIFY'     P@OPTN                                       CGL182
     C                   PARM      'CGL182'      P@SARD                                       CGL182
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL182
      *                                                                                       CGL182
     C                   IF        (P@RTCD <> *BLANKS) AND (P@RTCD <> '*NRF')                 CGL182
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL182
     C                   EVAL      DBKEY = 'CGL182'                                           CGL182
     C                   EVAL      DBASE = 5                                                  CGL182
     C                   EXSR      *PSSR                                                      CGL182
     C                   ENDIF                                                                CGL182
      *                                                                                       CGL182
     C                   IF        P@RTCD = *BLANKS                                           CGL182
     C                   EVAL      CGL182 = 'Y'                                               CGL182
     C                   ENDIF                                                                CGL182
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C                   PARM      *BLANKS       P@OP02                                       CSC024
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 2                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
     C/COPY WNCPYSRC,GLH00450
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLBITHV020
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
(c) Finastra International Limited 2001
