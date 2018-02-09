     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL Cancelled Deals Housekeeping')                *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000110 - Midas DL Cancelled Deals Housekeeping             *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL098 *CREATE     Date 06Oct17               *
      *                 nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL098 - Cancelled Deal Numbers                              *
      *                                                               *
      *****************************************************************
     FDLCANCTD  UF   E           K DISK    INFSR(*PSSR)
     FDL000110P1O    E             PRINTER INFDS(SPOOL)
     F                                     INFSR(*PSSR)

     D/EJECT
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnum1          S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
      *
     D RQDLN           S              3S 0
     D DIFLN           S              3S 0

     D SPOOL           DS
     D PSFile1                83     92
     D PSFNum1               123    124B 0
     D OflLn1                188    189B 0
     D SWRIT                 243    246B 0
     D PrtLn1                367    368B 0

      *
      ** Overlays
     D                 DS

      ** External Definitions
     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,PROCPARMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

      ** Field Definitions
     D DHRPD           S              4  0
     D HistCutOff      S              5  0
     D RECSD           S              5  0
     D Counter         S              5  0
     D start           S              5  0
     D date6           S              6  0
     D midas7          S              7

     C/EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+

     C                   Exsr      DeleteDeals

     C                   Write     DL000110H1
     C                   Write     DL000110T1

     C                   Exsr      #ZSFILE

      ** Terminate Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  DeleteDeals - Count and Delete Deals with Value date less    *
      *                than or equal to History cut off date          *
      *****************************************************************

     C     DeleteDeals   BEGSR

     c/exec sql
     c+ select count(*)
     c+ into :RECSD
     c+ from DLCANCTD
     c+ where CLVALD <= :HistCutOff
     c/end-exec

     c/exec sql
     c+ delete from DLCANCTD
     c+ where CLVALD <= : HistCutOff
     c+ with nc
     c/end-exec
     C                   If        SQLCOD <> 0 AND SQLCOD <> 100
     C                   Exsr      *PSSR
     C                   Endif

     C                   ENDSR
      *****************************************************************
      *                                                               *
      * #ZSFILE - Detail Spool File recorded by RCF                   *
      *                                                               *
      *****************************************************************
     C     #ZSFILE       BEGSR

      ** Ensure Detail Spool File recorded by RCF.

     C                   Eval      ZSnum = PSFNum1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C     ZSERR         IFeq      'Y'
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS '    PRTNC
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Data base error in file (file)
      *
     C     PRTNC         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALL      'AODEALR1'
     C                   PARM      '*MSG    '    PRTNC             7
     C                   PARM      '*FIRST  '    POPTN             7
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
     C     PRTNC         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Calculate History cut-off date
      *
     C                   Eval      DHRPD = BNDHRT * 31
     C                   Eval      HistCutOff = BJRDNB - DHRPD

     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
     C/EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2017
