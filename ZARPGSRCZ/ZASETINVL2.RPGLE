     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Settle instructions validation 2')            *
      *****************************************************************
      *                                                               *
      *  Midas - Common routing                                       *
      *                                                               *
      *  ZASETINVL2 - SETTLEMENT INSTRUCTIONS VALIDATION 2            *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD052228           Date 30Oct18               *
      *  Prev Amend No. MD041649           Date 29Sep16               *
      *                 MD039547           Date 20Sep16               *
      *                 MD038593  *CREATE  Date 09Jun16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052228 - Overridable message Settlement account is         *
      *             Referred is not displayed after clicking          *
      *             complete button in MAPY.                          *
      *  MD041649 - Validation during authorisation should be executed*
      *  MD039547 - Validate inactive account and a few adjustment on *
      *             refer account validation.                         *
      *  MD038593 - Validate settlement account refer debit/credit    *
      *             flag.                                             *
      *                                                               *
      *****************************************************************
     D @CUST           S              6
     D @CYCD           S              3
     D @ACCD           S             10
     D @ACSN           S              2
     D @NONB           S              2
     D @BRCD           S              3
     D @CSSN           S             10
     D @PNOI           S              1
     D @ACID           S             10

     D @BRCA           S              3
     D @TYPE           S              7
     D @NOSN           S              2
     D DDRONS          S             18
     D DDPONS          S             18
     D ##CALP          S              4
     D ##PCCY          S              3
     D ##RCCY          S              3
     D ##CSNM          S             10
     D ##BRCA          S              3
     D ##ACTN          S              1
     D ##PPAY          S              1
     D ##PREC          S              1
     D DDROBR          S              3
     D DDPOBR          S              3
     D CLE033          S              1

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3  0
     D WFldNameArr     S             10    DIM(75)

     D                 DS
     D  A#OURA                 1     18
     D  A#NOST                 1      2
     D  A#CNUM                 1      6
     D  A#RENO                 1     10
     D  A#ACOD                 7     16
     D  A#ACAS                 7     18
     D  A#ACSQ                17     18
     D  A#REST                 3     18
     D  A#RES2                11     18

      ** Receive Instructions OK flags
     D OKReceive       DS
     D  DDRscyOK                      1A
     D  DDRstmOK                      1A
     D  DDRonxOK                      1A
     D  DDRocnOK                      1A
     D  DDRobnOK                      1A
     D  DDRibnOK                      1A
     D  DDRibaOK                      1A
     D  DDRmacOK                      1A
     D  DDRexrOK                      1A
     D  DDRexiOK                      1A
     D  DDRbb1OK                      1A
     D  DDRbb2OK                      1A
     D  DDRbb3OK                      1A
     D  DDRbb4OK                      1A
     D  DDRbb5OK                      1A
     D  DDRbb6OK                      1A

      ** Payment Instructions OK flags
     D OKPayment       DS
     D  DDPscyOK                      1A
     D  DDPstmOK                      1A
     D  DDPonxOK                      1A
     D  DDRvnoOK                      1A
     D  DDCvmrOK                      1A
     D  DDPocnOK                      1A
     D  DDPobnOK                      1A
     D  DDRcrnOK                      1A
     D  DDRcraOK                      1A
     D  DDPibnOK                      1A
     D  DDPibaOK                      1A
     D  DDAwbnOK                      1A
     D  DDAwbaOK                      1A
     D  DDBennOK                      1A
     D  DDBenaOK                      1A
     D  DDDtp1OK                      1A
     D  DDDtp2OK                      1A
     D  DDDtp3OK                      1A
     D  DDDtp4OK                      1A
     D  DDDchgOK                      1A
     D  DDIc72OK                      1A
     D  DDBtb1OK                      1A
     D  DDBtb2OK                      1A
     D  DDBtb3OK                      1A
     D  DDBtb4OK                      1A
     D  DDBtb5OK                      1A
     D  DDBtb6OK                      1A
     D  DDPmacOK                      1A
     D  DDPexrOK                      1A
     D  DDPexiOK                      1A

      ** Multibranch Indicator using RUNDAT.
     D RUNDAT          DS
     D  @MBIN                 13     13

      ** Screen Receive Instructions
     D ##RECS        E DS                  EXTNAME(SDESSRPD)

      ** Screen Payment Instructions
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)

      ** External DS for Account Details
     D ACCT          E DS                  EXTNAME(ACCNTAB)

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** External DS for Long Dummy Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External DS for Short Dummy Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  WLCD         E                     EXTFLD(LCD)

      ** External DS for Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDREACCD      E                     EXTFLD(QQACCD)

      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,ERR_ARRAYS
      *******************************************************************
      *  Main Processing
      *******************************************************************

      ** Initial Processing

     C                   EXSR      SRINIT

      ** Receipt Instructions

     C                   IF        ##ACTN <> 'R'
     C                             OR ##ACTN = 'R' AND ##CALP = 'LEND'                      MD039547
     C                             AND ##PREC <> 'Y'                                        MD039547
     C                             OR ##ACTN = 'R' AND ##CALP = 'MAPY'
     C                             AND ##PREC <> 'Y'
     C                   IF        ##PREC <> 'Y'
     C                   EXSR      RECEIP
     C                   ENDIF
     C                   ENDIF

      ** Payment Instructions

     C                   IF        (##ACTN = 'I' OR ##ACTN = 'A')
     C                             AND ##PPAY <> 'Y'
     C                             OR ##ACTN = 'X' AND ##PPAY = 'Y'
     C                             OR ##ACTN = 'R' AND ##CALP = 'MAPY'
     C                             AND ##PPAY <> 'Y'
     C                             OR ##ACTN = 'X' AND ##CALP = 'MAPY'
     C                             AND ##PPAY = ' ' AND ##PREC = 'Y'
     C                             OR ##ACTN = 'R' AND ##CALP = 'LEND'                      MD039547
     C                             AND ##PREC <> 'Y'                                        MD039547
     C                             OR ##ACTN = 'X' AND ##PPAY <> 'Y'                        MD041649
     C                             AND (##CALP = 'LEND' OR ##CALP = 'DEAM'                  MD041649
     C                               OR ##CALP = 'FXDL' OR ##CALP = 'NASP')                 MD041649
     C                   IF        ##PPAY <> 'Y'
     C                   EXSR      PAYMNT
     C                   ENDIF
     C                   ENDIF

      ** Return

     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* RECEIP - Validate Receipt Instructions                        *
     C*                                                               *
     C*****************************************************************
     C     RECEIP        BEGSR

     C                   EVAL      A#OURA = DDRONS
     C                   IF        DDRSTM = '04'
     C                   MOVEL     ##CSNM        @ACID
     C                   EVAL      @CYCD = ##RCCY
     C                   EVAL      @ACCD = BMACCD
     C                   EVAL      @ACSN = '01'
     C                   EVAL      @BRCA = ##BRCA
     C                   IF        ##CALP <> 'SSI '
     C                   EXSR      ACACCT
     C                   TESTB     '0'           RETB                     91
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDRSTM = '01' OR DDRSTM = '02'
     C                             OR DDRSTM = '07' OR DDRSTM = '08'
     C                             OR DDRSTM = '12'
     C                   EVAL      @CYCD = ##RCCY
     C                   EVAL      @NONB = A#NOST
     C                   EXSR      ACNOST
     C                   EVAL      @ACID = *BLANKS
     C                   MOVEL     A7CUST        @ACID
     C                   EVAL      @CYCD = ##RCCY
     C                   EVAL      @ACCD = A7ACCD
     C                   MOVE      A7ACSN        @ACSN
     C                   EVAL      @BRCA = A7BRCD
     C                   EXSR      ACACCT
     C                   TESTB     '0'           RETB                     91
     C                   ENDIF

     C                   IF        DDRSTM = '05'
     C                   EVAL      @ACID = *BLANKS
     C                   MOVEL     A#CNUM        @ACID
     C                   EVAL      @CYCD = ##RCCY
     C                   EVAL      @ACSN = A#ACSQ
     C                   EVAL      @ACCD = A#ACOD
     C                   EVAL      @BRCA = DDROBR                                           MD039547
     C                   EXSR      ACACCT
     C                   TESTB     '0'           RETB                     91
     C                   ENDIF

     C                   IF        DDRSTM = '14'
     C                   MOVEL     A#RENO        @ACID
     C                   EVAL      @CYCD = *BLANKS
     C                   EVAL      @ACSN = *BLANKS
     C                   EVAL      @ACCD = *BLANKS
     C                   EVAL      @BRCA = *BLANKS
     C                   EXSR      ACACCT
     C                   TESTB     '0'           RETB                     91
     C                   TESTB     '4'           RETB                     93                MD039547
     C                   ENDIF

     C                   IF        *IN91 = '1'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1960'
     C                   EVAL      DDRonxOK = 'W'
     C                   EXSR      SRExtChkRefAc                                            MD052228
     C                   ENDIF
      *                                                                                     MD039547
      ** Inactive                                                                           MD039547
      *                                                                                     MD039547
     C     *IN93         IFEQ      '1'                                                      MD039547
     C                   ADD       1             WIdx                                       MD039547
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD039547
     C                   EVAL      WMsgIDArr(WIdx) = '5017861'                              MD039547
     C                   EVAL      DDPonxOK = 'W'                                           MD039547
     C                   ENDIF                                                              MD039547
      *                                                                                     MD039547
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PAYMNT - Validate Payment Instructions                        *
      *                                                               *
      *****************************************************************
     C     PAYMNT        BEGSR

     C                   EVAL      A#OURA = DDPONS
     C                   IF        DDPSTM = '04'
     C                   MOVEL     ##CSNM        @ACID
     C                   EVAL      @CYCD = ##PCCY
     C                   EVAL      @ACCD = BMACCD
     C                   EVAL      @ACSN = '01'
     C                   EVAL      @BRCA = ##BRCA
     C                   IF        ##CALP <> 'SSI '
     C                   EXSR      ACACCT
     C                   TESTB     '1'           RETB                     92
     C                   ENDIF
     C                   ENDIF

     C                   IF        DDPSTM = '01' OR DDPSTM = '02'
     C                             OR DDPSTM = '07' OR DDPSTM = '08'
     C                             OR DDPSTM = '12'
     C                   EVAL      @CYCD = ##PCCY
     C                   EVAL      @NONB = A#NOST
     C                   EXSR      ACNOST
     C                   EVAL      @ACID = *BLANKS
     C                   MOVEL     A7CUST        @ACID
     C                   EVAL      @CYCD = ##PCCY
     C                   EVAL      @ACCD = A7ACCD
     C                   MOVE      A7ACSN        @ACSN
     C                   EVAL      @BRCA = A7BRCD
     C                   EXSR      ACACCT
     C                   TESTB     '1'           RETB                     92
     C                   ENDIF

     C                   IF        DDPSTM = '05'
     C                   EVAL      @ACID = *BLANKS
     C                   MOVEL     A#CNUM        @ACID
     C                   EVAL      @CYCD = ##PCCY
     C                   EVAL      @ACSN = A#ACSQ
     C                   EVAL      @ACCD = A#ACOD
     C                   EVAL      @BRCA = DDPOBR                                           MD039547
     C                   EXSR      ACACCT
     C                   TESTB     '1'           RETB                     92
     C                   ENDIF

     C                   IF        DDPSTM = '14'
     C                   MOVEL     A#RENO        @ACID
     C                   EVAL      @CYCD = *BLANKS
     C                   EVAL      @ACSN = *BLANKS
     C                   EVAL      @ACCD = *BLANKS
     C                   EVAL      @BRCA = *BLANKS
     C                   EXSR      ACACCT
     C                   TESTB     '1'           RETB                     92
     C                   TESTB     '4'           RETB                     94                MD039547
     C                   ENDIF

     C                   IF        *IN92 = '1'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1961'
     C                   EVAL      DDPonxOK = 'W'
     C                   EXSR      SRExtChkRefAc                                            MD052228
     C                   ENDIF
      *                                                                                     MD039547
      ** Inactive                                                                           MD039547
      *                                                                                     MD039547
     C     *IN94         IFEQ      '1'                                                      MD039547
     C                   ADD       1             WIdx                                       MD039547
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                             MD039547
     C                   EVAL      WMsgIDArr(WIdx) = '5017861'                              MD039547
     C                   EVAL      DDPonxOK = 'W'                                           MD039547
     C                   ENDIF                                                              MD039547
      *                                                                                     MD039547
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * ACNOST - Access Nostro Details
      *
      *****************************************************************
     C     ACNOST        BEGSR

     C                   CALL      'AONOSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST
     C                   PARM                    @CYCD
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @ACSN
     C                   PARM                    @NONB
     C                   PARM      *BLANKS       @BRCD
     C                   PARM      *BLANKS       @CSSN
     C                   PARM      *BLANKS       @PNOI
     C     SDNOST        PARM      SDNOST        DSSDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * ACACCT - Access Account Details
      *
      *****************************************************************
     C     ACACCT        BEGSR

     C                   CLEAR                   DSSDY
     C                   CLEAR                   ACCT
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    @ACID
     C                   PARM                    @CYCD
     C                   PARM                    @ACCD
     C                   PARM                    @ACSN
     C                   PARM                    @BRCA
     C                   PARM                    @TYPE
     C                   PARM                    @NOSN
     C     ACCT          PARM      ACCT          DSSDY
     C                   MOVEL     DSSDY         ACCT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
     C                   EVAL      *IN91 = '0'
     C                   EVAL      *IN92 = '0'
     C                   SETOFF                                       9394                  MD039547

      ** Get Module details

     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Database Error

     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 903
     C                   EXSR      SRERR
     C                   END

      ** Get Retail details

     C                   IF        BGRTBN = 'Y' OR BGIOAC = 'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY

      ** Database Error

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBASE = 904
     C                   EXSR      SRERR
     C                   END
     C                   END

      ** Access SAR details file to determine if CLE033 is switched on

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE033'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   EVAL      CLE033 = 'N'
     C                   IF        @RTCD = *Blanks
     C                   EVAL      CLE033 = 'Y'
     C                   ENDIF

      ** Receive and Payment accounts and settlement branches
      ** If not multi-branching

     C                   IF        @MBIN <> 'Y'
     C                   IF        CLE033 = 'Y' AND DDRSTM <> '09'
     C                   MOVEL     DDRONX        DDRONS
     C                   MOVEL     *BLANKS       DDROBR
     C                   ENDIF
     C                   IF        CLE033 = 'Y' AND DDPSTM <> '09'
     C                   MOVEL     DDPONX        DDPONS
     C                   MOVEL     *BLANKS       DDPOBR
     C                   ENDIF
     C                   ENDIF

      ** Receive and payment accounts and settlement branches
      ** If multi-branching

     C                   IF        @MBIN = 'Y'
     C                   IF        DDRSTM = '05'
     C                             OR (CLE033 = 'Y' AND DDRSTM = '09')
     C                   MOVE      DDRONX        DDRONS
     C                   MOVEL     DDRONX        DDROBR
     C                   ELSE
     C                   MOVEL     DDRONX        DDRONS
     C                   MOVEL     *BLANKS       DDROBR
     C                   END
     C                   IF        DDPSTM = '05'
     C                             OR (CLE033 = 'Y' AND DDPSTM = '09')
     C                   MOVE      DDPONX        DDPONS
     C                   MOVEL     DDPONX        DDPOBR
     C                   ELSE
     C                   MOVEL     DDPONX        DDPONS
     C                   MOVEL     *BLANKS       DDPOBR
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn

      ** Inputs
      ** Code to indicate calling function
     C                   PARM                    ##CALP

      ** Payment currency
     C                   PARM                    ##PCCY

      ** Receive currency
     C                   PARM                    ##RCCY

      ** Customer shortname (or number)
     C                   PARM                    ##CSNM

      ** Booking branch
     C                   PARM                    ##BRCA

      ** Payment instructions - screen format
     C                   PARM                    ##PAYS

      ** Receive instructions - screen format
     C                   PARM                    ##RECS

      ** Action Code
     C                   PARM                    ##ACTN

      ** Protect Payment Field
     C                   PARM                    ##PPAY

      ** Protect Receipt Field
     C                   PARM                    ##PREC

      ** Outputs
      ** Payment instructions OK
     C                   PARM                    OKPayment

      ** Receive instructions OK
     C                   PARM                    OKReceive

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning Messages
     C                   PARM                    WFldNameArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx

      ** Read data area - RUNDAT

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD052228
      *                                                               *                     MD052228
      *  SRExtChkRefAc - Extra Check on Account for Referred DR/CR    *                     MD052228
      *                                                               *                     MD052228
      *****************************************************************                     MD052228
     C     SRExtChkRefAc BEGSR                                                              MD052228
                                                                                            MD052228
     C                   IF        ##CALP = 'MAPY'                                          MD052228
                                                                                            MD052228
      ** Also check for referred credit on Receive Side                                     MD052228
                                                                                            MD052228
     C     ##PREC        IFNE      'Y'                                                      MD052228
     C                   TESTB     '1'           RETB                     92                MD052228
     C     *IN92         IFEQ      '1'                                                      MD052228
     C                   ADD       1             WIdx                                       MD052228
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                             MD052228
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1961'                              MD052228
     C                   MOVE      'W'           DDRonxOK                                   MD052228
     C                   END                                                                MD052228
     C                   ENDIF                                                              MD052228
                                                                                            MD052228
      ** Also check for referred debit on Payment Side                                      MD052228
                                                                                            MD052228
     C     ##PPAY        IFNE      'Y'                                                      MD052228
     C                   TESTB     '0'           RETB                     91                MD052228
     C     *IN91         IFEQ      '1'                                                      MD052228
     C                   ADD       1             WIdx                                       MD052228
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                             MD052228
     C                   EVAL      WMsgIDArr(Idx) = 'ESM1960'                               MD052228
     C                   MOVE      'W'           DDPonxOK                                   MD052228
     C                   END                                                                MD052228
     C                   ENDIF                                                              MD052228
                                                                                            MD052228
     C                   ENDIF                                                              MD052228
                                                                                            MD052228
     C                   ENDSR                                                              MD052228
      *****************************************************************                     MD052228
      /EJECT                                                                                MD052228
      *****************************************************************
      *                                                               *
      * SRERR - Exception Errors                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR

     C                   EVAL      RetCodeIn = '*ERROR '
     C                   EVAL      DBPGM = 'ZASETINVAL'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2016
