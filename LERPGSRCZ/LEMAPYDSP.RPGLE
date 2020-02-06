     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment input - Display')            *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYDSP - LE Manual Repayment Input - Display              *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Manual Repayment input function.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP086             Date 08Jun05               *
      *                 BUG3114            Date 08Aug04               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FLEMAPYDDF CF   E             WORKSTN INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      * Copile time array   (*before STD_D_SPEC with CPY@ definition)
     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @NAR            S             50    DIM(1) CTDATA PERRCD(1)
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the LE standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
      *
     D @EI             S              1    DIM(50)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D ScrMaPy       E DS                  EXTNAME(LEMAPYPD)
     D OKScrMaPy     E DS                  EXTNAME(LEEMAPYPD)
      *
     D                 DS
     D  DDFOTX                 1     70
     D  D#LNRF                48     53
     D  D#VDAT                55     60
     D  D#LSSQ                65     67
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ***  Main processing
 
     C                   EXSR      MAIN
 
      ***  Return
 
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKScrMaPy     @EI
      *
      ***  Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     50
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ***  Do while error messages found
      ***  write error messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZMSID
     C                   MOVEL     MsgDtaArr(C)  ZMSDA
      *
     C     MsgIdArr(C)   IFNE      *BLANKS
     C                   EXSR      ERRMSG
     C                   END
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Do while warning messages found
      ***  Write warning messages (with or without data) to sub-file
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZMSID
     C                   MOVEL     WMsgDtaArr(C) ZMSDA
      *
     C     WMsgIdArr(C)  IFNE      *BLANKS
     C                   EXSR      ERRMSG
     C                   END
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Position cursor on action code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      ***  Enable key fields
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      ***  Enable detail fields (all fields except action code, loan number and sequence)
      *
     C     @EDTFD        COMP      'Y'                                7070
 
      ***  Enable function keys
 
     C     @EINKG        COMP      'Y'                                    71    F07
     C     @EINKH        COMP      'Y'                                    72    F08
     C     @EINKJ        COMP      'Y'                                    73    F10
     C     @EINKN        COMP      'Y'                                    74    F14
     C     @EINKP        COMP      'Y'                                    75    F15
     C     @EINKQ        COMP      'Y'                                    76    F16
 
      ***  Display Fields
 
     C     @EIN67        COMP      'Y'                                    67    Cust Ok
     C     @EIN88        COMP      'Y'                                    88    CLE003
     C     @EIN89        COMP      'Y'                                    89    CLE007
     C                   If        DDACTN <> 'I' and DDCUST <> *blanks
     C                   MOVE      *ON           *IN67
     c                   Endif
     C                   MOVE      *OFF          *IN87
     C     WProcTypLoan  IFEQ      70
     C     WproctypLoan  OREQ      71
     C     CLE005        ANDEQ     'Y'
     C                   MOVE      *ON           *IN87                          Sign not Amend
     C                   Endif
      *
     C                   Eval      *IN86 = *Off                                 Write off amend.
     C                   if        DDACTN <> 'I'                                only for insert
     C                   Eval      *IN86 = *ON
     C                   Endif
 
      ***  Key Fields not yet Validated
 
     C                   if        *IN69 = *off                                 Key fields not OK
     C                   Eval      *IN77 = *Off                                   past due details
     C                   Eval      *IN78 = *ON                                  ND principal
     C                   Eval      *IN79 = *ON                                  ND interest/W/hold
     c                   Eval      *IN80 = *ON                                  ND Total
     C                   Eval      *IN81 = *ON                                  ND Penality
     C                   Eval      *IN82 = *ON                                  ND Write-off
     C                   Eval      *IN08 = *ON                                  ND Int Ref   BUG3114
     C                   Eval      *IN09 = *ON                                  ND Chg Ref   BUG3114
     C                   Endif
 
      ***  Key fields already Validated
 
     C                   if        *IN69 = *ON                                  Key fields OK
      *
      ***  Protect Amendable fields if Action is not 'I'
      *
      ***  If you are not working with Past due/reapyement Scheduled expected details
      ***  ('Expected Value Date' field is blanks)
      *
     C                   if        DDEVAL = *blanks                             Not Past due details
     c                   Eval      *IN77 = *Off                                 'Past Due Y/N'
     C                   Eval      *IN78 = *ON                                  ND principal
     C                   Eval      *IN79 = *ON                                  ND interest/W/hold
     c                   Eval      *IN80 = *ON                                  ND Total
     C                   Eval      *IN81 = *ON                                  ND Penality
     C                   Eval      *IN86 = *ON                                  Protect W-off
     C                   Else
      *
      ***  Else you are working with Past Due/Repayment Scheduled Details
      *
     c                   Eval      *IN77 = *ON                                  ND 'Past Due Y/N'
     C                   Eval      *IN78 = *Off                                 disp  principal
     C                   Eval      *IN79 = *ON                                  Disp interest/W/hold
     c                   Eval      *IN80 = *Off                                 Disp Total
 
      ***  display Past due/Repayment Schedule depending on Passed details
 
     C                   if        WrkExpAmdtp = 'PD'                           Expected Amend Type
     C                   Eval      *IN79 = *off
     C                   Endif
 
     C                   if        WrkExpAmdtp = 'RE'                           Expected Amend Type
     C                   Select
     C                   When      WrkRepaytp = 1                               Loan Repayment type
     C                   Eval      *IN80 = *on
     C                   When      WrkRepaytp = 2
     C                   When      WrkRepaytp = 3
     C                   Eval      *IN78 = *on
     C                   endsl
     C                   Endif
 
      ***  Penality : depends of CLE003
 
     C                   if        *IN88 = *ON                                  CLE003 activated
     C                   Eval      *IN81 = *OFF                                 Display Penality
     C                   Else
     C                   Eval      *IN81 = *ON                                  ND Penality
     C                   endif
      *
     C                   endif                                                  DDEVAL
 
      ***  Write-Off Depends on *IN82, only for RE or PD for repayment to put in Losts&Profits
      *                                                                                      BUG3114
     C                   If        CLE028 = 'Y'                                              BUG3114
     C                             and WProcTypLoan = 80                                     BUG3114
      *                                                                                      BUG3114
      ** For flat rate personal loans, if ADIF is 'Y' show interest                          BUG3114
      ** refunded and if ADCF is 'Y' show charges refunded.                                  BUG3114
      *                                                                                      BUG3114
     C                   if        @ADIF = 'Y'                                               BUG3114
     C                   MOVE      *OFF          *IN08                                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      *ON           *IN08                                       BUG3114
     C                   ENDIF                                                               BUG3114
     C                   if        @ADCF = 'Y'                                               BUG3114
     C                   MOVE      *OFF          *IN09                                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      *ON           *IN09                                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
      ** If Add on interest is 'Y', prevent entry to interest repayment                      BUG3114
      ** and non-display the outstanding interest to date                                    BUG3114
      *                                                                                      BUG3114
     C                   if        @ADIF = 'Y'                                               BUG3114
     C                   MOVE      *ON           *IN07                                       BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      *OFF          *IN07                                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
     C                   Else                                                                BUG3114
     C                   MOVE      *OFF          *IN07                                       BUG3114
     C                   MOVE      *ON           *IN08                                       BUG3114
     C                   MOVE      *ON           *IN09                                       BUG3114
     C                   ENDIF                                                               BUG3114
      *                                                                                      BUG3114
 
     C     *IN77         COMP      '0'                                    82
      *
     C                   endif                                                  *IN69 = *ON
 
      ***  Text when Insert run successfully
 
     C                   MOVEL     *BLANKS       DDFOTX
     C     @LSSQ         IFNE      *BLANKS
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @LSSQ         D#LSSQ
     C                   MOVEL     @LNRF         D#LNRF
     C                   MOVEL     @VDAT         D#VDAT
     C                   MOVEL     *BLANKS       @LSSQ
     C                   MOVEL     *BLANKS       @LNRF
     C                   MOVEL     *BLANKS       @VDAT
     C                   ENDIF
 
      ***  Write message sub-file, details and footer screen
 
     C                   TIME                    DDTIME
     C                   WRITE     LEMAPYD1
     C                   WRITE     LEMAPYC1
     C                   WRITE     LEMAPYF1
 
      ***  If not write only, Read details screen
 
     C     WriteOnly     IFNE      'Y'
     C                   READ      LEMAPYD1                               99
     C                   ENDIF
 
      ***  Clear message subfile
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
 
      ***  Set screen error indicators OFF
 
     C                   MOVEA     @Z0           *IN(10)
 
      ***  Set return keys
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
     C                   MOVE      *INKQ         @INKQ
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages                               *
      *****************************************************************
     C     ERRMSG        BEGSR
 
      ***  Display error message
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LEMAPYDSP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing.                                  *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ***  Parameters
 
     C     *ENTRY        PLIST
 
      ***  INPUT PARAMETERS
 
     C                   PARM                    RetCodeIn                       Ret Code
     C                   PARM                    ScrMaPy                         MR in Scn fmt
     C                   PARM                    OKScrMaPy                       OK flags
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Enabled key & detail fields
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      ***  Enabled function keys
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1
      ***  Activated Features/Flags
     C                   PARM                    @EIN67            1            Cust Checked
     C                   PARM                    CLE005            1            Feature
     C                   PARM                    @EIN88            1            CLE003
     C                   PARM                    @EIN89            1            CLE007
     C                   PARM                    WrkExpAmdtp       2            PD/RE Amend Type
     C                   PARM                    WrkRepaytp        1 0          Loan Repay. Type
     C                   PARM                    WProcTypLoan      2 0          Loan Proc. Type
      ***  Succesful insert - Fields for DDFOTX
     C                   PARM                    @LSSQ             3
     C                   PARM                    @LNRF             6
     C                   PARM                    @VDAT             6
      ***  Add on Interest/Charge flag                                                       BUG3114
     C                   PARM                    @ADIF             1                         BUG3114
     C                   PARM                    @ADCF             1                         BUG3114
 
      ***  OUTPUT PARAMETERS
 
      ***  Function keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    @INKQ             1
      ***  Write screen with no read indicator
     C                   PARM                    WriteOnly         1
 
      ***  Initialize program name
 
     C                   MOVEL     'LEMAPYDSP'   DBPGM
 
      ***  Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
 
      ***  Access bank details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *                                                                                      BUG3114
      ** Access Switchable SAR details for the existence of CLE028                           BUG3114
      *                                                                                      BUG3114
     C                   CALLB     'AOSARDR0'                                                BUG3114
     C                   PARM      *BLANK        @RTCD                                       BUG3114
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3114
     C                   PARM      'CLE028'      @SARD                                       BUG3114
      *                                                                                      BUG3114
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3114
     C                   MOVE      'Y'           CLE028            1                         BUG3114
     C                   ELSE                                                                BUG3114
     C                   MOVE      'N'           CLE028                                      BUG3114
     C                   ENDIF                                                               BUG3114
                                                                                             BUG3114
      ***  Message subfile control
 
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
 
      ***  initiliase display fields Depending of input
 
     C                   MOVEA     '00000000000' *IN(67)
     C                   MOVEA     '000000000000'*IN(78)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** @Z0
000000000000000000000000000000000000000000000000000000000000
** @NAR
Sequence no. allocated to last repayment input 666666 666666 is 333
**  CPY@
(c) Finastra International Limited 2002
