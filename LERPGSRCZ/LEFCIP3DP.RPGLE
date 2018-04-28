     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facilitites LUX Display')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2005 Module                                     *
      *                                                               *
      *  LEFCIP3DP - Midas LE FCIP Display - Extension                *
      *                                                               *
      *  Function: This module will allow input of the customer       *
      *            facility extension details.                        *
      *                                                               *
      *  Component of: SP8LE0005  - Midas SP LE non-kernel validation *
      *                             function                          *
      *                                                               *
      *  Called by: LEFCIP2RP - LE Facilities Repair - Extension.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FLEFCIPLDF CF   E             WORKSTN
     F                                     RENAME(LEFCIPDSP:SCREEN)
 
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
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
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
 
      **   Named constants
      **   ===============
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
     D @EI             S              1    DIM(3)
 
     D OkFlags       E DS                  EXTNAME(LEEFCLX1PD)
     D FCIPScnFmtEx  E DS                  EXTNAME(LEFCRXPD)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Midas SD Bank details ICD file
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External DS for SAR details
      *
      **
      **   Declared variables
      **   ==================
      **
 
     D PRunDate        S              7
     D C               S              2S 0
     D E               S              2S 0
      *
      ** Define *entry parameters
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
      ** Send program message parameters
      *
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
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
     C                   EVAL      *InLr   = *On
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Main processing                                      *
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
      *
     C                   DOU       C       > 3
     C                   IF        @EI(C)  = 'N' Or
     C                             @EI(C)  = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
     C                   DOW       C       < ArrayMax And
     C                             FldNameArr(C) <> *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             C
     C                   ENDDO
      *
     C                   EVAL      SPGM = PSProcMod
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SJOB = PSJobName
      *
      ** Protect all fields
      *
     C                   IF        @EIN20  =  'Y'
     C                   EVAL      *In20   = *On
     C                   ENDIF
      *
      ** Enable functions keys
      *
     C                   IF        @EINKE  = 'Y'
     C                   EVAL      *In35   = *On
     C                   ENDIF
     C                   IF        @EINKJ  = 'Y'
     C                   EVAL      *IN40   = *ON
     C                   ENDIF
      *
      ** Write message subfile and details screen
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
     C                   MOVEA     '000'         *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKE         @INKE
     C                   MOVE      *INKJ         @INKJ
     C                   MOVE      *INKL         @INKL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCLEAR - Clear message file                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCLEAR       BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSEND - Send message to program's message queue.             *
      *                                                               *
      *****************************************************************
      *
     C     SRSEND        BEGSR
      *
     C                   IF        ZAPGMQ  = *BLANK
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
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Standards Input Parameters
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    FCIPScnFmtEx
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
     C                   MOVEL     'LEFCIP3DP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVEL     'LEFCIP3DP'   ##PGM
      *
      ** Messages file
      *
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
