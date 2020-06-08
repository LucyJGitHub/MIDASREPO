     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Log mandatory report request')                *
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility Module                       *
      *                                                               *
      *  FC1000 - Log mandatory report request                        *
      *                                                               *
      *  Function:  Written for User Defined Correspondence; create   *
      *             a new RCF report request for UDC generated        *
      *             print.                                            *
      *                                                               *
      *  Called By: CG5200                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG7269            Date 25May05               *
      *                 TDA035             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 18Jan95               *
      *                 X00000                  00XXX00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BUG7269 - FCC0301 FC0600 DBERR in MUSER                      *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  01   -    XX                                                 *
      *  50   -    CHAIN fail                                         *
      *                                                               *
      *****************************************************************
      *
      /COPY WNCPYSRC,FC1000FPG
     F*FCREPTL1* IF   E           K DISK                                                    MD055265
     F**********                           INFSR(SRFILE)                                    MD055265
     F*FCRCOML1* IF   E           K DISK                                                    MD055265
     F**********                           INFSR(SRFILE)                                    MD055265
     FFCMOUTL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FMUSER     IF   E           K DISK
     F                                     INFSR(SRFILE)
     FFCRREQPD  O    E           K DISK
     F                                     INFSR(SRFILE)
      /EJECT
      ** Copyright statement
      *
      *COPY*CGCPYSRC,SRERRE                                                                 MD055265
      /COPY CGCPYSRC,SRERRDLE                                                               MD055265
      /COPY WNCPYSRC,FC1000EPG
      /EJECT
     D ##MOUT        E DS                  EXTNAME(FCMOUTL1)
      ** External DS for FCMOUTL1
      *
     D ##RREQ        E DS                  EXTNAME(FCRREQL1)
      ** External DS for FCRREQL1
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Data Area for run-date
      *
     D***D#PHAS*   E DSMPHAS                                                                  CCB020
      ***Data*Area*for*Midas*phase*************************************                       CCB020
      *
     D REPSEQ          DS
     D  SEQ                    1      5  0
      ** Report sequence number
      *
     D                 DS
     D*I********    'MIDAS    '               1  10 K#MDS                                    BUG7269
     D  K#MDS                  1     10    INZ('MIDAS     ')                                       B
      ** 'MIDAS' key for CHAIN/ing MUSER
      *
     D #DRCOM          DS
     D  #KRNAM                 1     10
     D  #KCNAM                11     20
     D  #KCSEQ                21     25
      ** Used to report database error
      *
     D PGNME           C                   CONST('CBC001001')
      ** Constant for calling program CBC001001                                               CCB020
      *                                                                                       CCB020
     D FCRCOM        E DS                  EXTNAME(FCRCOJW0)                                MD055265
     D FCREPT        E DS                  EXTNAME(FCREPJW0)                                MD055265
      *COPY*CGCPYSRC,SRERRI                                                                 MD055265
      /COPY WNCPYSRC,FC1000IPG
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRINIT - Initial processing                                 *
      *   SRDEFN - Look up report description and component defn.     *
      *   SROPIN - Look up mandatory output instructions              *
      *   SRBRCH - Access user's default branch                       *
      *   SRNEXT - Access next sequence number                        *
      *   SRCRTR - Create report request                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    R0RTN             7            Return code
     C                   PARM                    #2RSEQ            5            Rept. seq.
     C                   PARM                    #3RNAM           10            Rept. name
     C                   PARM                    #4CNAM           10            Comp. name
     C                   PARM                    #5CSEQ            5            Comp. seq.
     C                   PARM                    #6LEVL            1            Level
     C                   PARM                    #7ENTY            3            Entity
     C                   PARM                    #8OPIN           10            O/P ins.
      *
      ** Initial processing
     C                   EXSR      SRINIT
      *
      ** Look up report description and component definition
     C                   EXSR      SRDEFN
      *
      ** Look up mandatory output instructions
     C                   EXSR      SROPIN
      *
      ** Access user's default branch
     C                   EXSR      SRBRCH
      *
      ** Access next sequence number from DTAARA/REPSEQ
     C                   EXSR      SRNEXT
      *
      ** Create report request
     C                   EXSR      SRCRTR
      *
      /COPY WNCPYSRC,FC1000PRC
     C                   RETURN
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Purpose     :  Initial processing                             *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright statement
     C                   MOVE      CPYR@#        ACT@             80
      *
      ** Key lists:
      **  o FCRCOML1
     C     #KRCOM        KLIST
     C                   KFLD                    #KRNAM           10
     C                   KFLD                    #KCNAM           10
     C                   KFLD                    #KCSEQ            5
      *
      ** Access run-date
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
      *
      ** Access Midas phase
     C********** *NAMVAR   DEFN MPHAS     D#PHAS                                              CCB020
     C**********           IN   D#PHAS                                                        CCB020
      *                                                                                       CCB020
      ** Call program CBC001001 to check if system in COB or IC                               CCB020
      ** If the return value is *YES, system is in COB                                        CCB020
      *                                                                                       CCB020
     C                   CALL      PGNME
     C                   PARM                    COBST             4
      *
      ** Access current time
     C                   TIME                    ##TIME            6 0
      *
     C     EXINIT        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRDEFN                                         *
      * Purpose     :  Look up report description and component       *
      *                definition                                     *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRDEFN        BEGSR
      *
      ** Access report description information from FCREPTL1
     C*****#3RNAM        CHAIN     FCREPTL1                           50                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT                                                                        MD055265
     C+ from FCREPJW0                                                                       MD055265
     C+ where DXRNAM = :#3RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
      *
      ** Database error if description not found
     C******IN50         IFEQ      '1'                                                      MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   MOVEL     'FCREPTL1'    W0FILE
     C                   MOVEL     #3RNAM        W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Access component definition from FCRCOML1
     C                   MOVEL     #3RNAM        #KRNAM
     C                   MOVEL     #4CNAM        #KCNAM
     C                   MOVEL     #5CSEQ        #KCSEQ
     C*****#KRCOM        CHAIN     FCRCOML1                           50                    MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM                                                                        MD055265
     C+ from FCRCOJW0                                                                       MD055265
     C+ where D3RNAM = :#KRNAM and D3COTT = :#KCNAM and D3CSEQ = :#KCSEQ                    MD055265
     C/END-EXEC                                                                             MD055265
      *
      ** Database error if definition not found
     C******IN50         IFEQ      '1'                                                      MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   MOVEL     'FCREPTL1'    W0FILE
     C                   MOVEL     #DRCOM        W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     EXDEFN        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SROPIN                                         *
      * Purpose     :  Look up mandatory output instructions          *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SROPIN        BEGSR
      *
      ** Clear output instruction data structure
     C                   CLEAR                   ##MOUT
      *
      ** Access default output instruction file
     C     #3RNAM        CHAIN     FCMOUTL1                           50
      *
      ** If no output instruction found, set up default values
     C     *IN50         IFEQ      '1'
      *
     C                   MOVEL     DXDFTO        D2DFTO
     C                   MOVEL     ##USR         D2USRO
     C                   MOVEL     'N'           D2ARMF
     C                   MOVEL     'N'           D2AROD
     C                   MOVEL     ##USR         D2DFTU
      *
      ** Set 'distribution required' only if multibranched; 'Y' for
      ** entity level, 'N' for system level.
     C     AGMBIN        IFEQ      'Y'
     C     #7ENTY        IFEQ      *BLANK
     C                   MOVEL     'Y'           D2DRQD
     C                   ELSE
     C                   MOVEL     'N'           D2DRQD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If output instruction parameter passed to this program,
      ** overwrite existing value.
     C     #8OPIN        IFNE      *BLANKS
     C                   MOVEL     #8OPIN        D2DFTO
     C                   ENDIF
      *
     C     EXOPIN        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRBRCH                                         *
      * Purpose     :  Access user's default branch                   *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRBRCH        BEGSR
      *
      ** Access user details for report user
     C     D2DFTU        CHAIN     MUSERDDF                           50
      *
      ** If not found, access details for default user MIDAS. If MIDAS
      ** found, set
     C     *IN50         IFEQ      '1'
     C     K#MDS         CHAIN     MUSERDDF                           50
     C     *IN50         IFEQ      '0'
     C**********           MOVEL'MIDAS'   D2DFTU                                             BUG7269
     C                   MOVEL     K#MDS         D2DFTU
     C                   ELSE
      *
      ** If still not found, database error
     C                   MOVEL     'MUSER   '    W0FILE
     C                   MOVEL     'MIDAS'       W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C     EXBRCH        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRNEXT                                         *
      * Purpose     :  Get next report sequence number                *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRNEXT        BEGSR
      *
      ** Obtain next sequence number from DTAARA/REPSEQ, and update       LN1183
      ** this data area for next request                                  LN1183
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      SEQ           #2RSEQ
     C                   ADD       1             SEQ
     C                   OUT       REPSEQ
      *
     C     EXNEXT        TAG
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRCRTR                                         *
      * Purpose     :  Create report request                          *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRCRTR        BEGSR
      *
      ** Clear report request data structure
     C                   CLEAR                   ##RREQ
      *
      ** Set up details for request
     C                   MOVEL     #2RSEQ        D5RQSQ
     C                   MOVEL     #3RNAM        D5RNAM
     C                   MOVEL     D2DFTO        D5SOID
     C                   MOVEL     #6LEVL        D5LVL
     C                   MOVEL     #7ENTY        D5ETTY
     C********** D#PHAS    IFEQ 'C'                                                           CCB020
     C********** D#PHAS    OREQ 'D'                                                           CCB020
     C********** D#PHAS    OREQ 'E'                                                           CCB020
     C     COBST         IFEQ      '*YES'
     C                   MOVEL     'N'           D5IPCY
     C                   MOVEL     'Y'           D5COBR
     C                   ELSE
     C                   MOVEL     'Y'           D5IPCY
     C                   MOVEL     'N'           D5COBR
     C                   ENDIF
     C                   MOVEL     'N'           D5PDFL
     C                   MOVEL     D2DLS1        D5DLS1
     C                   MOVEL     D2DLS2        D5DLS2
     C                   MOVEL     D2USRO        D5USRO
     C                   MOVEL     D2ARMF        D5ARMF
     C                   MOVEL     D2AROD        D5AROD
     C                   MOVEL     D2DRQD        D5DRQD
     C                   MOVEL     D2DFTU        D5USRR
     C                   MOVEL     DBRN          D5DBRN
     C                   MOVEL     ##TIME        D5RQTM
     C                   MOVEL     #4CNAM        D5COTT
     C                   MOVEL     #5CSEQ        D5CSEQ
     C                   Z-ADD     *ZERO         D5TNLU
      *
      ** Write to file
     C                   WRITE     FCRREQD0
      *
     C     EXCRTR        TAG
     C                   ENDSR
      *
      /EJECT
      /COPY WNCPYSRC,FC1000CPG
      *COPY*CGCPYSRC,SRERRC                                                                 MD055265
      /COPY CGCPYSRC,SRERRCLE                                                               MD055265
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD055265
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD055265
**CTDATA CPY@
(c) Finastra International Limited 2001
