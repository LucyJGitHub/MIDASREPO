     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Failed Standing Orders Report')               *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE0733 - Failed Standing Orders Report                       *
      *                                                               *
      *  Function:  This program will list all Standing Orders that   *
      *             failed or that were not processed during CoB.     *
      *                                                               *
      *  Called By: REC0733 - Failed Standing Orders Report Control   *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR786413           Date 09Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8188            Date 25Apr05               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 23Mar04               *
      *                 CRE013  *CREATE    Date 29Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR786413 - REC0733 00001 - Printer overflow                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8188 - I/O error CPF5004 was detected in file RE0733P1    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase of Midas Account Code from 4 Bytes to 10   *
      *           Bytes. Recompile due to changes in RE0733P1 and     *
      *           RESTORPD.                                           *
      *  CRE013 - Report of Failed Standing Orders                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
     FRESTORPD  IF   E             DISK
     FRE0733P1  O    E             PRINTER INFDS(SPOOL1) USROPN
     FRE0733AU  O    E             PRINTER INFDS(SPOOLU) USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
     D SPOOL1          DS
      * P1 printer file information data structure
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  SFPLE                152    153B 0
     D  SFOVR                188    189B 0
     D  SFCUR                367    368B 0
 
     D SPOOLU          DS
      * AU printer file information data structure
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  SFPLEU               152    153B 0
     D  SFOVRU               188    189B 0
     D  SFCURU               367    368B 0
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D ArrREJC         S              2    DIM(15)
      * Rejection Code Array
 
     D ArrREJD         S             22    DIM(15) CTDATA PERRCD(1)
      * Rejection Description Array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data Structure for Bank Details Access Program
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for Currency Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Long Data Structure for Access Programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Short Data Structure for Access Programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
     D MaxRptLine      S              3  0
     D CurRptLine      S              3  0
     D FirstPage       S              1A
 
     D X               S              2  0
     D Y               S              2  0
     D RecordCount     S              5  0
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Loop until EOF
     C                   Read      RESTORPD
     C                   DoW       NOT %EOF(RESTORPD)
 
     C                   Add       1             RecordCount
 
     C                   Exsr      SrGenReport
 
     C                   Read      RESTORPD
     C                   EndDo
 
      ** Output report trailer
 
     C                   If        RecordCount <> 0
      **   Open & enroll report file
     C                   Exsr      SrOpenP1
 
      **   Check for overflow line, output heading if required
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C**********         If        ((MaxRptLine-CurRptLine) < 2) OR                         AR786413
     C                   If        ((MaxRptLine-CurRptLine) < 3) OR                         AR786413
     C                             FirstPage = 'Y'
     C                   Write     HEADP1
     C                   Eval      FirstPage = 'N'
     C                   Endif
 
     C                   Write     TRAILP1
     C                   Endif
 
      ** Generate Audit Report
     C                   Exsr      SrAuditRept
 
      ** Terminate program
     C                   Eval      *INLR = *On
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGenReport - Generate Report                                 *
      *                                                               *
      *****************************************************************
     C     SrGenReport   BegSr
 
      ** Open & enroll report file
     C                   Exsr      SrOpenP1
 
      ** Output hyphen
     C                   Eval      *IN30 = *On
 
      ** Set up report fields
     C                   Move      STOR          RSTOR
     C                   Move      DRBR          RDRBR
     C                   Move      DCUS          RDCUS
     C                   Move      PCCY          RDCCY
     C                   Move      DACD          RDACD
     C                   Move      DACS          RDACS
     C                   Move      CBRC          RCBRC
     C                   Move      CCUS          RCCUS
     C                   Move      PCCY          RCCCY
     C                   Move      CSCA          RCSCA
     C                   Move      CACD          RCACD
     C                   Move      PCCY          RPCCY
 
      ** Retrieve CCY details
     C                   Move      PCCY          @CYCD
     C                   Exsr      SrCcyDtls
 
      ** Format Amount
     C                   CallB     'ZSEDIT'
     C                   Parm      PAMT          ZFLD15
     C                   Parm      A6NBDP        ZDECS
     C                   Parm      'J'           ZECODE
     C                   Parm      *Blank        ZOUT21
     C                   Move      ZOUT21        RPAMT
 
     C                   Move      PNAR          RPNAR
 
      ** Rejection Code
     C                   Z-Add     0             Y
     C                   Z-Add     1             X
     C                   MoveA     REJC          ArrREJC(X)
     C                   Move      ArrREJC(X)    Y
     C                   If        Y <> 0
     C                   Move      ArrREJD(Y)    RRRSN
     C                   Endif
 
      ** Check for overflow line, output heading if required
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C**********         If        ((MaxRptLine-CurRptLine) < 2) OR                          BUG8188
     C                   If        ((MaxRptLine-CurRptLine) < 3) OR                          BUG8188
     C                             FirstPage = 'Y'
     C                   Write     HEADP1
     C                   Eval      FirstPage = 'N'
     C                   Endif
 
      ** Output detail line
     C                   Write     DETAIL
 
      ** More Rejection Reason ?, output them in the next line
     C                   Add       1             X
     C                   Move      ArrREJC(X)    Y
     C                   DoW       Y <> *Zero
 
     C                   Clear                   DETAIL
     C                   Move      ArrREJD(Y)    RRRSN
 
      ** Check for overflow line, output heading if required
     C                   Z-Add     SFOVR         MaxRptLine
     C                   Z-Add     SFCUR         CurRptLine
     C**********         If        ((MaxRptLine-CurRptLine) < 2)                            AR786413
     C                   If        ((MaxRptLine-CurRptLine) < 3)                            AR786413
     C                   Write     HEADP1
     C                   Endif
 
      ** Hide hyphen
     C                   Eval      *IN30 = *Off
 
      ** Output detail line
     C                   Write     DETAIL
 
      ** Read the next Rejection Code
     C                   Add       1             X
     C                   Move      ArrREJC(X)    Y
     C                   EndDo
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCcyDtls - Access Currency Details                           *
      *                                                               *
      *****************************************************************
     C     SrCcyDtls     BegSr
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blank        @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm                    @CYCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
     C                   If        @RTCD <> *Blank
     C     *LOCK         In        LDA
     C                   Eval      DBFILE =  'SDCURRPD'
     C                   Eval      DBKEY  =  @CYCD
     C                   Eval      DBPGM  =  'RE0733'
     C                   Eval      DBASE  =  2
     C                   Out       LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open and Enroll report file                        *
      *                                                               *
      *****************************************************************
     C     SrOpenP1      BegSr
 
      ** Open & enroll report file
     C                   If        NOT %OPEN(RE0733P1)
     C                   OPEN      RE0733P1
     C                   Z-ADD     SFNUM         ZSNUM
     C                   Call      'ZSFILE'
     C                   Parm      *BLANKS       ReptSeq           5
     C                   Parm      *BLANKS       Entity            3
     C                   Parm                    SFILE
     C                   Parm                    ZSNUM             6 0
     C                   Parm                    ZSERR             1
     C                   If        ZSERR = 'Y'
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  'RE0733P1'
     C                   Eval      DBPGM  =  'RE0733'
     C                   Eval      DBASE  =  3
     C                   Out       LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAuditRept - Generate Audit Report                           *
      *                                                               *
      *****************************************************************
     C     SrAuditRept   BegSr
 
      ** Open & enroll report file
     C                   If        NOT %OPEN(RE0733AU)
     C                   Open      RE0733AU
     C                   Z-Add     SFNUMU        ZSNUMU
     C                   Call      'ZSFILE'
     C                   Parm      *BLANKS       ReptSeq           5
     C                   Parm      *BLANKS       Entity            3
     C                   Parm                    SFILEU
     C                   Parm                    ZSNUMU            6 0
     C                   Parm                    ZSERRU            1
     C                   If        ZSERRU = 'Y'
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  'RE0733AU'
     C                   Eval      DBPGM  =  'RE0733'
     C                   Eval      DBASE  =  4
     C                   Out       LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   DUMP
     C                   Endif
     C                   Endif
 
      ** Output audit heading
     C                   Write     HEADAU
 
      ** Output audit detail
     C                   If        *INU7 = *Off AND
     C                             *INU8 = *Off
     C                   If        RecordCount <> 0
     C                   Z-Add     RecordCount   RCOUNT
     C                   Write     CONTROL
     C                   Else
     C                   Write     NODTLS
     C                   Endif
 
     C                   Else
     C                   Write     DBERROR
     C                   Endif
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BegSr
      *
      ** Read in Installation Data
      *
     C     *DTAARA       Define                  RUNDAT
     C     *DTAARA       Define                  LDA
     C                   In        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   If        AGDFF = 'M'
     C                   Eval      *IN98 = *ON
     C                   Endif
      *
      ** Access Bank details
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       @RTCD             7
     C                   Parm      '*FIRST  '    @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C     @RTCD         IfNE      *BLANKS
     C     *LOCK         In        LDA
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBPGM  =  'RE0733'
     C                   Eval      DBASE  =  1
     C                   Out       LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Eval      RecordCount = 0
     C                   Eval      FirstPage   = 'Y'
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
      ** Generate Audit Report
     C                   Exsr      SrAuditRept
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** - ArrREJC
DR A/C DOES NOT EXIST
DR A/C IS CLOSED
DR A/C IS BLOCKED
DR A/C IS BANKRUPT
DR A/C HAS BAD DEBT
DR A/C IS INACTIVE
DR A/C IS REFERRED
INSUFFICIENT FUNDS
CR A/C DOES NOT EXIST
CR A/C IS CLOSED
CR A/C IS BLOCKED
CR A/C IS BANKRUPT
CR A/C HAS BAD DEBT
CR A/C IS INACTIVE
CR A/C IS REFERRED
