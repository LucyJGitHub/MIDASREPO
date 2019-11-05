     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Display 1')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP1DP - LE Customer Loans Display                        *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the Customer Loans screen input function.      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 246178             Date 05Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10671R          Date 07Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 10Feb03               *
      *                 CAP074  *CREATE    Date 28Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  246178 - Could not display message other than GBLERMSGF      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A. Added     *
      *           Settlement Allocation indicator field.              *
      *  CLE031 - Lending Enhancements. Additional fields.            *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
     FLECLIP1DDFCF   E             WORKSTN INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
      * This array has been reduced as error indicators do not go up to 70 to free additional inds
      * NOTE: Array at bottom of code has been reduced but cannot be commented
     D @Z0             S              1    DIM(50) CTDATA PERRCD(50)
     D @NAR            S             40    DIM(1) CTDATA PERRCD(1)
      *
     D @EI             S              1    DIM(60)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, SHORT data structure
      *
     D Clip01        E DS                  EXTNAME(LECLI1PD)
     D OKClip01      E DS                  EXTNAME(LEECLI1PD)
      *                                                                                       CER020
      ** External DS for SAR Details                                                          CER020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER020
      *
     D                 DS
     D  DDFOTX                 1     40
     D  DDSIDN                10     15
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *                                                                                       CER020
      ** Switchable feature for CER020                                                        CER020
     D CER020          S              1A                                                      CER020
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      **   Initial processing
      *
     C                   EXSR      INIT
      *
      ***  Main processing
      *
     C                   EXSR      MAIN
      *
      ***  Return
      *
     C     @INKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   END
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT  - Initial processing                                    *
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Check type of processing
      *
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing                                        *
      *****************************************************************
     C     MAIN          BEGSR
      *
      ***  Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKClip01      @EI
      *
      ***  If a loan is reversed or matured, display message on the screen
      *
     C                   MOVEL     *BLANKS       DDNARR
     C                   MOVE      *OFF          *IN85
     C     DDACTN        IFEQ      'E'
     C     PLnRcdId      IFEQ      'R'
     C     PLnRcdId      OREQ      'M'
     C     PLnRcdId      IFEQ      'R'
     C     'RECORD'      CAT       'REVERSED':1  DDNARR
     C                   ELSE
     C     'RECORD'      CAT       'MATURED ':1  DDNARR
     C                   END
     C                   MOVE      *ON           *IN85
     C                   END
     C                   END
      *
      ***  Initialize action code
      ***  Set the action code to 'E' in case of action code '1'
      *
     C                   MOVEL     *BLANKS       SaveAction        1
     C     DDACTN        IFEQ      '1'
     C                   MOVEL     DDACTN        SaveAction
     C                   MOVEL     'E'           DDACTN
     C                   END
      *
      ***  Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C     C             DOUGT     60
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
     C                   EXSR      ERRMSG
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
     C                   EXSR      ERRMSG
      *
     C                   ADD       1             C
     C                   END
      *
      ***  Position cursor on action code if it is blank
      *
     C     DDACTN        COMP      *BLANK                                 68
      *
      ***  Enable key fields (action code & Loan number)
      *
     C     @EKYFD        COMP      'Y'                                6969
      *
      ***  Enable detail fields (all fields except action code & loan number)
      *
     C     @EDTFD        COMP      'Y'                                7070
      *
      ***  Enable function keys
      *
     C     @EINKN        COMP      'Y'                                    72    F14
     C     @EINKP        COMP      'Y'                                    73    F15
     C     @EINKG        COMP      'Y'                                    74    F07
     C     @EINKH        COMP      'Y'                                    74    F08
     C     @EINKI        COMP      'Y'                                    75    F09
     C     @EINKJ        COMP      'Y'                                    76    F10
      *
      ***  Text = SUCCESSFUL INSERT
      *
     C                   MOVEL     *BLANKS       DDFOTX
     C     @SIDN         IFNE      *BLANKS
     C     SaveACTN      ANDEQ     'I'
     C                   MOVEL     @NAR(1)       DDFOTX
     C                   MOVEL     @SIDN         DDSIDN
     C                   MOVEL     *BLANKS       @SIDN
     C                   END
      *
      ***  Write message sub-file, details and footer screen
      *
     C                   WRITE     LECLIPC1
     C                   WRITE     LECLIPD1
     C                   WRITE     LECLIPF1
     C                   MOVEL     DDACTN        SaveACTN          1
      *
      ***  Read details screen,
      *
      ***  If not write only
      *
     C     WriteOnly     IFNE      'Y'
     C                   READ      LECLIPD1                               99
     C                   ENDIF
      *
      ***  Clear message subfile
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
      ***  Set screen error indicators OFF
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      ***  Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
     C                   MOVE      *INKI         @INKI
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKN         @INKN
     C                   MOVE      *INKP         @INKP
      *
      ***  Restore action code
      *
     C     SaveAction    IFNE      *BLANKS
     C                   MOVEL     SaveAction    DDACTN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ERRMSG  - Output error messages                               *
      *****************************************************************
     C     ERRMSG        BEGSR
      *
      ***  Display error message
      *
      *** 246178 - in Input message could be LERMSGF, Y2USRMSG or DRSMM and XXUSRMSG          246178
      *                                                                                       246178
     C                   Z-ADD     1             Index             1 0                        246178
     C                   DoW       Index < 5                                                  246178
     C                   SELECT                                                               246178
     C     Index         WhenEq    1                                                          246178
     C                   Movel(p)  'GBLERMSGF'   ZMSGF                                        246178
     C     Index         WhenEq    2                                                          246178
     C                   Movel(p)  'GBDRSMM'     ZMSGF                                        246178
     C     Index         WhenEq    3                                                          246178
     C                   Movel(p)  'GBY2USRMSG'  ZMSGF                                        246178
     C     Index         WhenEq    4                                                          246178
     C                   Movel(p)  'GBXXUSRMSG'  ZMSGF                                        246178
     C                   ENDSL                                                                246178
      *                                                                                       246178
     C                   CALL      'SDRTVTXT'                                                 246178
     C                   PARM                    ZMSID                                        246178
     C                   PARM                    ZMSGF                                        246178
     C                   PARM      *blanks       MSGTXT           80                          246178
     C                   if        %subst(MSGTXT:1:18) <>                                     246178
     C                             'Text not available'                                       246178
     C                             And MSGTXT <> *BLANKS                                      246178
     C                   Z-ADD     9             index                                        246178
     C                   Else                                                                 246178
     C                   Eval      Index = Index +1                                           246178
     C                   Endif                                                                246178
     C                   EndDo                                                                246178
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM      'LECLIP1DP'   ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZMSID             7            Message Id.
     C                   PARM                    ZMSGF                          Message file.
     C                   PARM                    ZMSDA           132            Message data.
     C                   PARM                    ZMSTP             7            Message type.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing.                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM                    RetCodeIn
      *
      ***  Loan (in screen format)
     C                   PARM                    Clip01
      *
      ***  Fields in error
     C                   PARM                    OKClip01
      *
      ***  Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ***  Succesful insert loan
      *
     C                   PARM                    @SIDN             6
      *
      ***  Calling type
      *
     C                   PARM                    LoanType          4
      *
      ***  Loan record Id
      *
     C                   PARM                    PLnRcdId          1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
      *
      ***  Write screen with no read indicator
      *
     C                   PARM                    WriteOnly         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP1DP'   DBPGM
      *
      ***  Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      *ON           *IN81
     C                   ENDIF
      *
      ***  Determine if Customer Lending Enhancements - Past Due Account
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE006            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE006
     C                   MOVE      '1'           *IN84
     C                   END
      *
      ***  Display Rollover Fixing Days if CLE011 is installed,
      ***  and initialize error indicator
      *
     C                   MOVE      'N'           CLE011            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE011'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE011
     C                   MOVE      '1'           *IN86
     C                   END
      *
      ***  Determine if BLI Lending Enhancements feature is installed
      *
     C                   MOVE      'N'           S01465            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01465
     C                   MOVE      '1'           *IN80
     C                   END
      *                                                                                       CER020
      ** Check if CER020 is enabled.                                                          CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       @RTCD                                        CER020
     C                   PARM      '*VERIFY'     @OPTN                                        CER020
     C                   PARM      'CER020'      @SARD                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        @RTCD = *BLANKS                                            CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
      *                                                                                       CER020
      ** Set On Indicator to display the new fields                                           CER020
      *                                                                                       CER020
     C                   EVAL      *IN60 = '1'                                                CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   EVAL      *IN60 = '0'                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *
      ***  Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     'GBLERMSGF'   ZMSGF            10
      *
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
**  CPY@
(c) Finastra International Limited 2002
** @Z0
00000000000000000000000000000000000000000000000000
** @NAR
Loan No. 999999 successfully inserted.
