     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE CLIP Display - Extension')
      *****************************************************************
      *                                                               *
      *  Misys - Lending Module                                       *
      *                                                               *
      *  LECLIP5DP - Midas LE CLIP Repair - Extension                 *
      *                                                               *
      *  Function:  This function displays the Extended Details       *
      *             screen of the Customers                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 246178             Date 01Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246178 - Could not display message other than GBLERMSGF      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
     FLECLIPD5DFCF   E             WORKSTN
     F                                     RENAME(LECLIPD5F6:SCREEN)
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** Ê Automatically included D-specs       Ê
      ** Ê ==============================       Ê
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
      ** Ê Manually included D-specs            Ê
      ** Ê =========================            Ê
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
     D @EI             S              1    DIM(12)
 
     D CLIPScnFmtEx  E DS                  EXTNAME(LECLRXPD)
     D OKCLEXFlgs    E DS                  EXTNAME(LEECLLX1PD)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access programs - short data structure
      *
 
 
      **
      **   Declared variables
      **   ==================
      **
      ** Standards Input Parameters
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
 
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
 
     D #1PTYP          S              2A
     D ULX004          S              1A
     D ULX612          S              1A
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      ** Main processing
      *
     C                   EXSR      SRMAIN
      *
      ** Return
      *
     C                   SETON                                        LR
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
     C                   MOVEA     OKCLEXFLGS    @EI
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     50            E                 2 0
      *
     C     C             DOUGT     12
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   END
     C                   ADD       1             C
     C                   ADD       1             E
     C                   END
      *
      ** Do while error messages found write error messages to subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     MsgIdArr(C)   ZAMSID
     C                   MOVEL     MsgDtaArr(C)  ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             C
     C                   END
      *
      ** Do while warning messages found write warning messages to
      ** subfile
      *
     C                   Z-ADD     1             C
     C     C             DOWLE     ArrayMax
     C     WFldNamArr(C) ANDNE     *BLANKS
     C                   MOVEL     WMsgIdArr(C)  ZAMSID
     C                   MOVEL     WMsgDtaArr(C) ZAMSDA
     C                   EXSR      SRSEND
     C                   ADD       1             C
     C                   ENDDO
      *
     C                   EVAL      SPGM = PSProcMod
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SJOB = PSJobName
      *
      ** Do not display degree of risk
      *
     C                   IF        ULX612 = 'Y' and
     C                             #1PTYP = '64' or #1PTYP = '65' or
     C                             #1PTYP = '68' or #1PTYP = '71'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
      *
      ** Protect all fields
      *
     C     @EIN20        COMP      'Y'                                    20
      *
      ** Enable functions keys
      *
     C     @EINKE        COMP      'Y'                                    35
     C     @EINKJ        COMP      'Y'                                    40
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
     C                   MOVEA     '000000000000'*IN(50)
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
     C                   PARM      SPGM          ZAPGMQ
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
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     SPGM          ZAPGMQ
     C                   ENDIF
      *                                                                                       246178
      *** 246178 - in Input message could be LERMSGF, Y2USRMSG or DRSMM and XXUSRMSG          246178
      *                                                                                       246178
     C                   Z-ADD     1             Index             1 0                        246178
     C                   DoW       Index < 5                                                  246178
     C                   SELECT                                                               246178
     C     Index         WhenEq    1                                                          246178
     C                   Movel(p)  'GBLERMSGF'   ZAMSGF                                       246178
     C     Index         WhenEq    2                                                          246178
     C                   Movel(p)  'GBDRSMM'     ZAMSGF                                       246178
     C     Index         WhenEq    3                                                          246178
     C                   Movel(p)  'GBY2USRMSG'  ZAMSGF                                       246178
     C     Index         WhenEq    4                                                          246178
     C                   Movel(p)  'GBXXUSRMSG'  ZAMSGF                                       246178
     C                   ENDSL                                                                246178
      *                                                                                       246178
     C                   CALL      'SDRTVTXT'                                                 246178
     C                   PARM                    ZAMSID                                       246178
     C                   PARM                    ZAMSGF                                       246178
     C                   PARM      *blanks       MSGTXT           80                          246178
     C                   if        %subst(MSGTXT:1:18) <>                                     246178
     C                             'Text not available'                                       246178
     C                             and MSGTXT <> *BLANKS                                      246178
     C                   Z-ADD     9             index                                        246178
     C                   Else                                                                 246178
     C                   Eval      Index = Index +1                                           246178
     C                   Endif                                                                246178
     C                   EndDo                                                                246178
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
     C                   PARM                    CLIPScnFmtEx
     C                   PARM                    OKCLEXFlgs
     C                   PARM                    #1PTYP
     C                   PARM                    ULX004
     C                   PARM                    ULX612
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
     C                   MOVEL     'LECLIP5DP'   DBPGM
      *
      ** Message subfile control
      *
     C                   MOVEL     'LECLIP5DP'   SPGM
      *
      **  Messages file
      *
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   ENDSR
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
(c) Misys International Banking Systems Ltd. 2005
