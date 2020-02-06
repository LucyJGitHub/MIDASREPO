     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits LUX Display')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMNASP2DP - Negotiable Assets Purchased                      *
      *                                                               *
      *  Function:  This function displays the Extended Details       *
      *             screen of NASP                                    *
      *                                                               *
      *  Component of:  SP8MM0003                                     *
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
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  *IN12  -  F12 Pressed goto previous screen                   *
      *  *IN20  -  Protect fields in enquire mode                     *
      *  *IN50  -  Error on field L6LXLUSU                            *
      *  *IN51  -  Error on field L6LXIM93                            *
      *  *IN52  -  Error on field L6LXCLAT                            *
      *  *IN53  -  Error on field L6LXCOAM                            *
      *  *IN54  -  Error on field L6LXSUBR                            *
      *  *IN55  -  Error on field L6LXMOBL                            *
      *  *IN56  -  Error on field L6LXRISC                            *
      *  *IN57  -  Error on field L6LXRATC                            *
      *  *IN58  -  Error on field L6LXSECQ                            *
      *  *IN59  -  Error on field L6LXSECT                            *
      *  *IN60  -  Error on field L6LXGUAC                            *
      *  *IN61  -  Error on field L6LXEVMT                            *
      *  *IN62  -  Error on field L6LXOPTP                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
     FMMNASPLDF CF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
     D C               S              2  0
     D E               S              2  0
     D ##PGM           S             10
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D @EI             S              1    DIM(14)
 
     D NwDlScnFmt    E DS                  EXTNAME(MMNPRXPD)
     D OkFlags       E DS                  EXTNAME(MMENPLX1PD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *
      **   Declared variables
      **   ==================
      *
 
      *
      ** Define *entry parameters
      *
      ** Standards Input Parameters
      *
     D @EINKJ          S              1
     D @EINKE          S              1
     D @EIN20          S              1
      *
      ** Extra Input Parameters
      *
     D SRER91          S              1
      *
      ** Standards Output Parameters
      *
     D @INKC           S              1
     D @INKL           S              1
     D @INKE           S              1
     D @INKJ           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
     C                   EXSR      SRMAIN
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMAIN - Main processing                                      *
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
      *
     C                   DOU       C > 14
     C                   IF        @EI(C) = 'N' OR
     C                             @EI(C) = 'W'
     C                   EVAL      *IN(E) = '1'
     C                   ENDIF
     C                   EVAL      C = C + 1
     C                   EVAL      E = E + 1
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
     C                   DOW       C <= ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C = C + 1
     C                   ENDDO
      *
      ** Do while warning messages found write warning messages to
      ** subfile
      *
     C                   Z-ADD     1             C
     C                   DOW       C <= ArrayMax AND
     C                             WFldNamArr(C) <> *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      SRSEND
     C                   EVAL      C = C + 1
     C                   ENDDO
      *
      ** Set screen protect/non-display indicators
      *
      *
      ** Protect all fields
      *
     C                   IF        @EIN20 = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   ELSE
     C                   EVAL      *IN20 = *OFF
     C                   ENDIF
      *
      ** Enable Funtion keys
      *
     C                   IF        @EINKE = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   ELSE
     C                   EVAL      *IN35 = *OFF
     C                   ENDIF
      *
     C                   IF        @EINKJ = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ELSE
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
      *
      ** Write message subfile and details screen
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     MMNASPF0
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     '00000000000' *IN(50)
     C                   MOVEA     '000'         *IN(61)
      *
      ** Set return keys
      *
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKE = *INKE
     C                   EVAL      @INKJ = *INKJ
     C                   EVAL      @INKL = *INKL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCLEAR - Clear message file                                  *
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
      * SRSEND - Send message to program's message queue.             *
      *****************************************************************
     C     SRSEND        BEGSR
      *
     C                   IF        ZAPGMQ = *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
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
      * *INZSR - Program Initialisation routine                       *
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
     C                   PARM                    NwDlScnFmt
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
     C                   MOVEL     'MMNASP2DP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVEL     'MMNASP2DP'   ##PGM
      *
      ** Call access program for bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      PSUser        SUSER
     C                   MOVE      PSJobName     SJOB
     C                   MOVE      PSProcName    SPGM
     C                   MOVE      PSProcName    WWPGM
     C                   MOVEL     'DRSMM'       ZAMSGF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  Program, module and procedure names for database error       *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
