     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *===============================================================*
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Details 2 LUX Display')
      *===============================================================*
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SESECS7DP - SE Securities Details 2 LUX Display              *
      *                                                               *
      *  Function:  This function is the screen display for input of  *
      *             Extended Securities Details                       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *  *IN03  -  F3 Pressed exit program                            *
      *  *IN05  -  F5 Pressed redisplay the screen                    *
      *  *IN10  -  F10 Pressed delete                                 *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN25  -  SFLEND control                                     *
      *  *IN35  -  Enable F5                                          *
      *  *IN40  -  Enable F10                                         *
      *  *IN50  -  Error on field L6LXLUSU                            *
      *  *IN51  -  Error on field L6LXSUBR                            *
      *  *IN52  -  Error on field L6LXIM93                            *
      *  *IN53  -  Error on field L6LXCLAT                            *
      *  *IN54  -  Error on field L6LXSECT                            *
      *  *IN55  -  Error on field L6LXROFC                            *
      *  *IN56  -  Error on field L6LXRATC                            *
      *  *IN57  -  Error on field L6LXVOTR                            *
      *  *IN58  -  Error on field L6LXSECD                            *
      *  *IN59  -  Error on field L6LXSNCD                            *
      *  *IN60  -  Error on field L6LXEEEM                            *
      *  *IN61  -  Error on field L6LXQUOT                            *
      *  *IN70  -  Error on field L6LXER91                            *
      *  *IN80  -  ULX008 is on - Enable handle of L6LXSECD L6LXSNCD  *
      *            L6LXEEM                                            *
      *  *IN81  -  ULX046 is on - Enable handle of L6LXQUOT           *
      *                                                               *
      *****************************************************************
 
     FSESEC2LDF CF   E             WORKSTN
     F                                     RENAME(SESEC2LF0:SCREEN)
 
      *===============================================================*
      ** Automatically included D-specs
      ** ==============================
      *
 
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
 
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Manually included D-specs
      ** =========================
      *
 
      ** Named constants
      ** ---------------
      *
 
      ** Arrays and Data Structures
      ** --------------------------
      *
 
      ** Error Indicators Array
      *
     D @EI             S              1    DIM(12)
 
      ** New Extension in Screen Format (#nLX)
      *
     D NwExScnFmt    E DS                  EXTNAME(SESERXPD)
 
      ** Error indicators (OK#6LX)
      *
     D OkFlags       E DS                  EXTNAME(SEESELX3PD)
      *
      ** Declared variables
      ** ------------------
      *
      ** Define *entry parameters
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Midas SD Bank details ICD file
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for SAR details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - short data structure
      *
 
      *
      ** Standards Input Parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
      *
      ** Standards Output Parameters
      *
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
      *
      ** "Standard" variables
      *
     D C               S              2P 0
     D E               S              2P 0
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
     D PRTCD           S              7
     D POPTN           S              7
     D L6LXER91        S              1
      *===============================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G      *
      *===============================================================*
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Return
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main processing                                     *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      ** Move 'OK' Flags into array (for checking)
      *
     C                   MOVEA     OkFlags       @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C
     C                   Z-ADD     50            E
 
     C     C             DOUGT     12
      *
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
      *
     C                   EVAL      C = C +  1
     C                   EVAL      E = E +  1
     C                   END
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
      *
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C = C +  1
     C                   END
      *
      ** Validate #6LXER91
      ** (screen field to ask for Guarantees to be maintained)
      *
     C                   IF        L6LXER91 <> 'Y' AND L6LXER91 <> 'N'
     C                   EVAL      *IN(70) = *ON
     C                   EVAL      ZAMSID  =  'LX61005'
     C                   EVAL      ZAMSDA  =  *BLANKS
     C                   EXSR      SRSEND
     C                   ENDIF
      *
      ** Do while warning messages found,
      ** write warning messages to subfile
      *
     C                   Z-ADD     1             C
 
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C =  C + 1
     C                   END
      *
      ** Enable fields protection
      *
     C                   IF        @EIN20 = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ENDIF
      *
      ** Enable functions keys
      *
     C                   IF        @EINKE = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
      *
     C                   IF        @EINKJ = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
      *
      ** Write message subfile and window details screen
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     SCREEN
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   EVAL      *IN(50) =  '0'
     C                   EVAL      *IN(51) =  '0'
     C                   EVAL      *IN(52) =  '0'
     C                   EVAL      *IN(53) =  '0'
     C                   EVAL      *IN(54) =  '0'
     C                   EVAL      *IN(55) =  '0'
     C                   EVAL      *IN(56) =  '0'
     C                   EVAL      *IN(57) =  '0'
     C                   EVAL      *IN(58) =  '0'
     C                   EVAL      *IN(59) =  '0'
     C                   EVAL      *IN(60) =  '0'
     C                   EVAL      *IN(61) =  '0'
     C                   EVAL      *IN(70) =  '0'
      *
      ** Set return keys
      *
     C                   EVAL      @INKC =  *INKC
     C                   EVAL      @INKE =  *INKE
     C                   EVAL      @INKJ =  *INKJ
     C                   EVAL      @INKL =  *INKL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SRCLEAR - Clear program message queue                        *
      *                                                               *
      *****************************************************************
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSEND - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
     C     SRSEND        BEGSR
      *
     C                   IF        ZAPGMQ  = *BLANK
     C                   EVAL      ZAPGMQ = ##PGM
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Standards Input Parameters
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    NwExScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKE
     C                   PARM                    @EIN20
     C                   PARM                    L6LXER91
      *
      ** Standards Output Parameters
      *
     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    @INKE
     C                   PARM                    @INKJ
      *
      ** Initialize program name
      *
     C                   MOVEL     PSProcMod     DBPGM
      *
      ** Message subfile control
      *
     C                   MOVEL     PSProcMod     ##PGM
      *
      ** Messages file
      *
     C                   EVAL      ZAMSGF  = 'SEUSRMSG'
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   EVAL      SJOB   = PSJobName
     C                   EVAL      SUSER  = PSUser
      *
      ** ULX008 - Commissariat aux Bourses.
      **          Set *IN80 to on if feature is enabled.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD   = *BLANK
     C                   EVAL      *IN80   = *ON
     C                   ENDIF
      *
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** ULX046 - Circulars 2002/170-174-175 Integration.
      **          Set *IN81 to on if feature is enabled.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'ULX046'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD   = *BLANK
     C                   EVAL      *IN81   = *ON
     C                   ENDIF
      *
     C                   IF        @RTCD <> *BLANKS AND @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error       *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
