     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas DL Cancelled Deals report')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000112 - Midas DL Cancelled Deals report program           *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2017            *
      *                                                               *
      *  Last Amend No. CDL098 *CREATE     Date 06Oct17               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL098 - Cancelled Deal Numbers                              *
      *
      *****************************************************************
     FTABTB10   IF   E             DISK    INFSR(*PSSR)
     FDLCANCI0  IF   E           K DISK    INFSR(*PSSR)
     FDL000112P1O    E             PRINTER INFDS(SPOOL)
     F                                     INFSR(*PSSR)
      *
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

     D BKBIN                   1      4B 0
      ** Blank Binary field for use
      *
      ** Overlays
     D                 DS

      ** External Definitions
     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,PROCPARMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access objects

      ** Field Definitions
     D NROF            S              4  0
     D DLNO            S              6
     D AUTH            S             30
     D VALD            S              7
     D LCDA            S              7
     D CHTP3           S              3
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
      *
      ** Get installation control data record 1.
      *
     C                   Read      TABTB10                                40
     C                   Write     DL000112H1
      *
     C                   If        *IN40 = *on
     C                   Seton                                            U8
     C                   Write     DL000112D1
     C                   Goto      ENDTAG
     C                   Endif

     C                   Read      DLCANCI0                               40
      *
      ** No details to report
      *
     C                   If        *IN40 = *on
     C                   Write     DL000112T2
     C                   Goto      ENDTAG
     C                   Endif

     C                   Exsr      ProcessDeals

     C                   Write     DL000112T1

     C     ENDTAG        TAG                                                    ** ENDTAG **

     C                   Exsr      #ZSFILE
     C                   Write     DL000112T3

      ** Terminate Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ProcessDeals - Read & Print Deal Cancellation records        *
      *****************************************************************

     C     ProcessDeals  BEGSR

      *
     C                   DoU       %EOF(DLCANCI0)
      *
      ** Set up information for output
      *
     C                   Move      CLDLNO        DLNO
     C                   Move      CLAUTH        AUTH
      *
      ** Convert original entry date
      *
     C                   Z-Add     CLVALD        start
     C                   CALLB     'ZDATE2'
     C                   PARM                    start
     C                   PARM                    bjdfin
     C                   PARM      *ZEROS        date6
     C                   PARM      *BLANKS       midas7
     C                   Move      midas7        VALD
      *
      ** Convert last change date
      *
     C                   Z-Add     CLLCD         start
     C                   CALLB     'ZDATE2'
     C                   PARM                    start
     C                   PARM                    bjdfin
     C                   PARM      *ZEROS        date6
     C                   PARM      *BLANKS       midas7
     C                   Move      midas7        LCDA
      *
      ** Determine last change type
      *
     C                   If        CLCHTP = 'A'
     C                   Eval      CHTP3 = 'AMD'
     C                   Else
     C                   Eval      CHTP3 = 'INS'
     C                   Endif
      *
      ** If overflow, write header

     C                   Eval      RQDLN = 10
     C                   Eval      DIFLN = OflLn1 - PrtLn1
     C                   If        DIFLN <= RQDLN
     C                   Write     DL000112H1
     C                   Endif
      *
     C                   Write     DL000112D2
      *
      ** Accumulate total of records on file.
      *
     C                   Add       1             NROF
      *
      ** Get next record
      *
     C                   Read      DLCANCI0
     C                   EndDO

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

     C     *Entry        PLIST
     C                   Parm                    PSeq
      *

     C                   ENDSR
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
     C/EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2017
