     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Display - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDCUS10DP - SD Customers Details Display - LU Window         *
      *                                                               *
      *  Function:  This function displays the Extended Details       *
      *             window screen of the Customers                    *
      *                                                               *
      *  Component of:  SP8SD0006 - Core Luxembourg service program   *
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
 
     FSDCUSD10DFCF   E             WORKSTN
 
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access progrmas, long data structure
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D @EI             S              1    DIM(5)
 
     D NwDlScnFmt    E DS                  EXTNAME(SDCURXPD)
     D OkFlags       E DS                  EXTNAME(SDECULX1PD)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
 
      ** Standards Input Parameters
     D PEINKJ          S              1
     D PEINKE          S              1
     D PEIN20          S              1
      ** Standards Output Parameters
     D PINKC           S              1
     D PINKL           S              1
     D PINKE           S              1
     D PINKJ           S              1
      *
     D WC              S              2  0
     D WE              S              2  0
      *
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
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
     C                   RETURN
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
     C                   Z-ADD     1             WC
     C                   Z-ADD     50            WE
      *
     C     WC            DOUGT     5
     C                   IF        @EI(WC)= 'N' OR
     C                             @EI(WC)= 'W'
     C                   MOVEL     '1'           *IN(WE)
     C                   ENDIF
     C                   ADD       1             WC
     C                   ADD       1             WE
     C                   ENDDO
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             WC
     C     WC            DOWLE     ArrayMax
     C     FldNameArr(WC)ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(WC)  ZAMSID
     C                   MOVEL     MsgDtaArr(WC) ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             WC
     C                   ENDDO
      *
      ** Do while warning messages found write warning messages to
      ** subfile
      *
     C                   Z-ADD     1             WC
     C     WC            DOWLE     ArrayMax
     C     WFldNamArr(WC)ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(WC) ZAMSID
     C                   MOVEL     WMsgDtaArr(WC)ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             WC
     C                   ENDDO
      *
      ** Protect all fields
      *
     C     PEIN20        COMP      'Y'                                    20
      *
      ** Enable functions keys
      *
     C     PEINKE        COMP      'Y'                                    35
     C     PEINKJ        COMP      'Y'                                    40
      *
      ** Write message subfile and window details screen
      *
     C                   WRITE     #MSGCTL
     C                   EXFMT     WINDOWF
      *
      ** Clear message subfile
      *
     C                   EXSR      SRCLEAR
      *
      ** Set screen error indicators off
      *
     C                   MOVEA     '00000'       *IN(50)
      *
      ** Set return keys
      *
     C                   MOVE      *INKC         PINKC
     C                   MOVE      *INKE         PINKE
     C                   MOVE      *INKJ         PINKJ
     C                   MOVE      *INKL         PINKL
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
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKE
     C                   PARM                    PEIN20
      *
      ** Standards Output Parameters
      *
     C                   PARM                    PINKC
     C                   PARM                    PINKL
     C                   PARM                    PINKE
     C                   PARM                    PINKJ
     C                   PARM                    BJMRDT
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDCUS10DP'   DBPGM
     C                   Eval      ##JOB = PSJobName
     C                   Eval      ##USR = PSUser
      *
      ** Message subfile control
      *
     C                   MOVEL     'SDCUS10DP'   ##PGM
      *
      ** Messages file
      *
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
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
**  CPY@
(c) Finastra International Limited 2005
