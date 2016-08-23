     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000006 - Midas OF Modelo 123 Request Screen                *
      *                                                               *
      *  Function:  This program allow users to request for Modelo    *
      *               123 report                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD034330           Date 07May15               *
      *  Prev Amend No. CRE104  *CREATE    Date 04Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034330 - Cancelled 123 request on the Modelo 123 screen is *
      *             saved on the audit file.                          *
      *  CRE104 - Modelo 123 and 193 Reports                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¶ F-specs                              ¶
      ** ¶ =======                              ¶
      ** +--------------------------------------+

      ** Modelo 123 Request Screen Display
     FRE000006DFCF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¶ Automatically included D-specs       ¶
      ** ¶ ==============================       ¶
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¶ End of automatically included D-specs¶
      ** ¶ =====================================¶
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¶ Manually included D-specs            ¶
      ** ¶ =========================            ¶
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¶ Named constants                      ¶
      ** ¶ ===============                      ¶
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¶ Arrays and Data Structures           ¶
      ** ¶ ==========================           ¶
      ** +--------------------------------------+

      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)

      ** Rundate data area
     D RUNDAT          DS
     D  WSUC                  11     11
     D  WMBIN                 13     13

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)

      ** External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for Modelo 123 Audit File
     D REM123        E DS                  EXTNAME(RE123ATD)

      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Output DS
     D POutFlds        DS           100
     D  PBranch                1      3A
     D  PMonth                 4      5A
     D  PYear                  6      9A
     D  PCompFlag             10     10A
     D  PFiller               11    100A

     D MOSNUM          S              2    DIM(12) CTDATA PERRCD(1)
     D ENDDAY          S              2    DIM(12) CTDATA PERRCD(1)

      ** +--------------------------------------+
      ** ¶ Declared variables                   ¶
      ** ¶ ==================                   ¶
      ** +--------------------------------------+

     D @RUN            S              1

      ** Database error workfields
     D POPTN           S              7

      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ('GBREUSRMSG')
     D PZMsgID         S             10
     D PZMsgDta        S             45A

      ** General workfields
     D WCDPL           S              1S 0
     D WSVAM           S             17  0
     D ZFLD63          S             63  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT85          S             85A
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A

      ** Parameters for ZALIGN3/ZSEDIT2
     D ZALIGNOK        S              1A
     D ZFIELD          S            130
     D ZADEC           S              2P 0
     D ZADIG           S              3P 0

     D ValidAll        S              1A

      ** Parameter for ZDATE9
     D WDateVar        DS
     D  WDateOut               1      8  0
     D   WYR                   1      4
     D   WMM                   5      6
     D   WDD                   7      8

      ** Data structure for ZDATE10
     D                 DS
     D  ZZDTIN                 1      8  0
     D  ZWYYYY                 1      4  0
     D  ZWMTH                  5      6  0
     D  ZWDAY                  7      8  0

      ** Parameters for ZDATE10
     D DateIn          S                   LIKE(ZZDTIN)
     D DaynoOut        S              5P 0

      ** Parameters for AOSVALR0
     D PRTCD           S              7A
     D PSVK01          S             20A
     D PSVL01          S            200A
     D PSVK02          S             20A
     D PSVL02          S            200A
     D PSVK03          S             20A
     D PSVL03          S            200A
     D PSVK04          S             20A
     D PSVL04          S            200A
     D PSVK05          S             20A
     D PSVL05          S            200A
     D PSVK06          S             20A
     D PSVL06          S            200A
     D PSVK07          S             20A
     D PSVL07          S            200A
     D PSVK08          S             20A
     D PSVL08          S            200A
     D PSVK09          S             20A
     D PSVL09          S            200A
     D PSVK10          S             20A
     D PSVL10          S            200A

      ** Parameters for AOBRCHR0
     D PBRCA           S              3A

      ** Temporary Storage
     D T1BRCA          S              3A
     D T1MNTH          S              2A
     D T1YEAR          S              4A
     D T1TRID          S             13A
     D T1AMNT          S             18A
     D T1RTRN          S              1A
     D T1PTID          S             13A
     D T1CNAM          S             40A
     D T1PHON          S              9A

     D WRtrn           S              1A
     D NumYrTimstmp    S              4  0
     D NumYrScrInpt    S              4  0
     D TChrYr2         S              2A   INZ(*BLANKS)
     D WMMDDYY         S              6A   INZ(*BLANKS)
     D TMMDDYY         S              6A   INZ(*BLANKS)
     D WInputDate      S               D   DATFMT(*ISO)
     D WTmStmDate      S               D   DATFMT(*ISO)
     D Numbers         C                   '0123456789'
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234-
     D                                      56789'
     D Chars           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ -
     D                                      abcdefghijklmnopqrstuvwxyz—Ò«Á'
     D WSTR            S              2A
     D WEND            S              2A
     D XCNT            S              2  0
     D SDate           S              8A
     D EDate           S              8A
     D SJRDNB          S              5  0
     D EJRDNB          S              5  0


      ** +--------------------------------------+
      ** ¶ End of D-specs                       ¶
      ** ¶ ==============                       ¶
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¶                                                                ¶
      ** ¶ Initial processing is performed automatically: the *INZSR is   ¶
      ** ¶ executed at program activation.                                ¶
      ** ¶                                                                ¶
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Clear Fields

     C/exec SQL                                                                             MD034330
     C+ set option commit = *CHG                                                            MD034330
     C/end-exec                                                                             MD034330

     C                   EXSR      SRClear

     C                   DOW       *IN03 = *Off

      ** Display Screen

     C                   TIME                    #1TIME
     C                   WRITE     RE000006C1
     C                   WRITE     RE000006F2
     C                   EXFMT     RE000006F1

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

     C                   IF        ValidAll = 'Y' and *IN03 = *OFF
     C
      ** If there are no changes from
      ** the prev. screen, then proceed

     C                   IF        #1MNTH = T1MNTH and
     C                             #1YEAR = T1YEAR and
     C                             #1TRID = T1TRID and
     C                             #1AMNT = T1AMNT and
     C                             #1RTRN = T1RTRN and
     C                             #1PTID = T1PTID and
     C                             #1CNAM = T1CNAM and
     C                             #1PHON = T1PHON and
     C                             #1BRCA = T1BRCA

      ** Populate RE123ATD Audit Table
     C                   EXSR      SRAudit
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
     C                   ENDIF

      ** Validate Fields

     C                   IF        *IN40 = *OFF and *IN03 = *OFF
     C                   EXSR      SRValidate
     C                   ENDIF

      ** Exit Program

     C                   IF        *IN03 = *ON
     C                   EXSR      SREnd
     C                   ENDIF

     C                   ENDDO

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClear - Clear screen fields                                 *
      *                                                               *
      *****************************************************************

     C     SRClear       BEGSR

     C                   EVAL      *IN28  = *OFF
     C                   EVAL      *IN29  = *OFF
     C                   EVAL      *IN30  = *OFF
     C                   EVAL      *IN31  = *OFF
     C                   EVAL      *IN32  = *OFF
     C                   EVAL      *IN33  = *OFF
     C                   EVAL      *IN34  = *OFF
     C                   EVAL      *IN35  = *OFF
     C                   EVAL      ValidAll = 'N'
     C                   EVAL      #1BRCA = *BLANKS
     C                   EVAL      #1MNTH = *BLANKS
     C                   EVAL      #1YEAR = *BLANKS
     C                   EVAL      #1TRID = *BLANKS
     C                   EVAL      #1AMNT = *BLANKS
     C                   EVAL      #1RTRN = *BLANKS
     C                   EVAL      #1PTID = *BLANKS
     C                   EVAL      #1CNAM = *BLANKS
     C                   EVAL      #1PHON = *BLANKS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Screen Fields                           *
      *                                                               *
      *****************************************************************

     C     SRValidate    BEGSR

     C                   MOVEA     '00000000'    *IN(28)

      ** Validate Branch

     C                   IF        #1BRCA <> *BLANKS

     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #1BRCA        PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PZMsgID = 'RE77134'
     C                   EXSR      SRZASNMS
     C                   ELSE
     C                   EVAL      #1BRCA = A8BRCD
     C                   MOVE      #1BRCA        XBRANCH           3
     C                   ENDIF

     C/exec sql
     C+ select * into :SDBRCH from SDBRCHPD
     C+ where A8BRCD = :#1BRCA and A8BICN in (select BBCUST
     C+ from SDCUSTPD where BBCOLC in (select A4CNCD
     C+ from SDCTRYPD where A4ISOC = 'ES'))
     C/end-exec

     C                   IF        SQLCOD <> 0
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PZMsgID = 'RE77135'
     C                   EXSR      SRZASNMS
     C                   ENDIF

     C                   ENDIF

     C                   IF        #1BRCA = *BLANKS
     C                   IF        PSVL03 = *BLANKS
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PZMsgID = 'RE77140'
     C                   EXSR      SRZASNMS
     C                   ELSE
     C                   MOVE      'ALL'         XBRANCH
     C                   ENDIF
     C                   ENDIF

      ** Validate Reporting Month

     C                   IF        #1MNTH = *Blanks OR (#1MNTH <> '01' AND
     C                             #1MNTH <> '02' and #1MNTH <> '03' AND
     C                             #1MNTH <> '04' and #1MNTH <> '05' AND
     C                             #1MNTH <> '06' and #1MNTH <> '07' AND
     C                             #1MNTH <> '08' and #1MNTH <> '09' AND
     C                             #1MNTH <> '10' and #1MNTH <> '11' AND
     C                             #1MNTH <> '12') OR
     C                             (#1MNTH = *BLANKS AND #1YEAR <> *BLANKS)
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PZMsgID = 'RE77132'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Validate Reporting Year

     C                   IF        #1YEAR = *Blanks
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PZMsgID = 'RE77123'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   IF        #1YEAR <> *Blanks

     C                   MOVE      #1YEAR        NumYrScrInpt

     C                   IF        NumYrScrInpt > NumYrTimstmp
     C                             AND #1MNTH = *BLANKS
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PZMsgID = 'RE77123'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDIF

      ** Validate Reporting Month together with the Year

     C                   IF        *IN29 = *OFF

     C                   MOVE      #1YEAR        TChrYr2
     C                   EVAL      WMMDDYY = #1MNTH + WDD + TChrYr2
     C                   EVAL      WInputDate = %DATE(WMMDDYY:*MDY0)
     C     WTmStmDate    SUBDUR    WInputDate    WMonthDiff:*M     3 0

     C                   MOVE      #1YEAR        NumYrScrInpt
     C                   MOVEL     PSVL04        WFLDYR            2 0

     C                   IF        (NumYrTimstmp - NumYrScrInpt) > WFLDYR
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PZMsgID = 'RE77122'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   IF        WMonthDiff <= 0
     C                   EVAL      *IN29 = *ON
     C                   EVAL      PZMsgID = 'RE77121'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDIF

      ** Validate Replacement Tax Return Flag

     C                   IF        #1RTRN <> 'Y' AND #1RTRN <> 'N' AND
     C                             #1RTRN <> *BLANKS
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PZMsgID = 'RE77136'
     C                   EXSR      SRZasnms
     C                   ELSEIF    #1RTRN = *BLANKS
     C/exec sql
     C+ Select * into :REM123 from RE123ATD where
     C+ MMNREQ = :#1MNTH and MYRREQ = :#1YEAR and MMBRCH = :XBRANCH
     C/end-exec
     C                   IF        SQLCOD = 0
     C                   EVAL      #1RTRN = 'Y'
     C                   ELSE
     C                   EVAL      #1RTRN = 'N'
     C                   ENDIF
     C                   EVAL      *IN32 = *OFF
     C                   ENDIF

      ** Validate Tax Return Identifier

     C                   IF        #1TRID <> *Blanks
     C     UP            CHECK     #1TRID
     C                   IF        %Found
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'RE77127'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN30 = *OFF
     C                   ENDIF

      ** Validate Amount from Previous Tax Return

     C                   IF        #1AMNT = *Blanks
     C                   IF        #1RTRN = 'Y'

     C/exec sql
     C+ Select * into :REM123 from RE123ATD where
     C+ MMNREQ = :#1MNTH and MYRREQ = :#1YEAR and MMBRCH = :XBRANCH
     C/end-exec
     C                   IF        SQLCOD = 0
     C                   MOVE      *BLANKS       ZFLD63
     C                   IF        MCTRTN = 'N'
     C                   MOVE      MTOINT        ZFLD63
     C                   ELSE
     C                   IF        MDTREQ <> BJRDNB
     C                   MOVE      MTOINT        ZFLD63
     C                   ELSE
     C                   MOVE      MAPTRN        ZFLD63
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      ZDECS = WCDPL
     C                   CALLB     'ZSEDIT2'
     C                   PARM                    ZFLD63
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT85
     C                   EVAL      #1AMNT = %SUBST(ZOUT85:67:18)
     C                   EVAL      *IN31 = *OFF

     C                   ELSE
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PZMsgID = 'RE77124'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   IF        #1AMNT <> *Blanks


     C                   EVAL      WSVAM = 0

     C                   EVAL      ZFIELD = *BLANKS

     C                   MOVE      #1AMNT        ZFIELD
     C                   MOVE      WCDPL         ZADEC
     C     17            SUB       WCDPL         ZADIG

     C                   CALLB     'ZALIGN3'     PPAR1

     C                   IF        ZALIGNOK = 'N'

     C                   EVAL      *IN31 = *ON
     C                   EVAL      PZMsgID = 'RE77125'
     C                   EXSR      SRZasnms

     C                   ELSEIF    ZALIGNOK = 'Y'

      ** Keep Amount in a numeric field

     C                   MOVE      ZFIELD        WSVAM

     C                   IF        WSVAM < 0
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PZMsgID = 'RE77125'
     C                   EXSR      SRZasnms

     C                   ELSE

      ** Edit the amount

     C                   MOVE      *BLANKS       ZFLD63
     C                   MOVE      WSVAM         ZFLD63
     C                   EVAL      ZDECS = WCDPL

     C                   CALLB     'ZSEDIT2'
     C                   PARM                    ZFLD63
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT85

     C                   EVAL      #1AMNT = %SUBST(ZOUT85:67:18)
     C                   EVAL      *IN31 = *OFF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Validate Previous Tax Return Identifier

     C                   IF        #1PTID <> *Blanks
     C     UP            CHECK     #1PTID
     C                   IF        %Found
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PZMsgID = 'RE77127'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      *IN33 = *OFF
     C                   ENDIF
     C                   ELSE
     C                   IF        #1RTRN ='Y'
     C/exec sql
     C+ Select * into :REM123 from RE123ATD where
     C+ MMNREQ = :#1MNTH and MYRREQ = :#1YEAR and MMBRCH = :XBRANCH
     C/end-exec
     C                   IF        SQLCOD = 0
     C                   EVAL      #1PTID = MTRTID
     C                   EVAL      *IN33 = *OFF
     C                   ELSE
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PZMsgID = 'RE77145'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN33 = *OFF
     C                   ENDIF
     C                   ENDIF

     C                   IF        #1RTRN = 'N' and
     C                             #1AMNT <> *Blanks or
     C                             #1RTRN = 'N' and
     C                             #1PTID <> *Blanks
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PZMsgID = 'RE77146'
     C                   EXSR      SRZasnms
     C                   ENDIF
      ** Validate Contact Person

     C                   IF        #1CNAM <> *BLANKS
     C     Chars         CHECK     #1CNAM
     C                   IF        %FOUND
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PZMsgID = 'RE77143'
     C                   EXSR      SRZASNMS
     C                   ENDIF
     C                   ELSE
     C                   EVAL      #1CNAM = PSVL01
     C                   ENDIF
      *
     C                   IF        #1CNAM = *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PZMsgID = 'RE77137'
     C                   EXSR      SRZASNMS
     C                   ENDIF

      ** Validate Contact Telephone

     C                   IF        #1PHON <> *BLANKS
     C     Numbers       CHECK     #1PHON
     C                   IF        %FOUND
     C                   EVAL      *IN35 = *ON
     C                   EVAL      PZMsgID = 'RE77144'
     C                   EXSR      SRZASNMS
     C                   ENDIF
     C                   ELSE
     C                   EVAL      #1PHON = PSVL02
     C                   ENDIF

     C                   IF        #1PHON = *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      PZMsgID = 'RE77138'
     C                   EXSR      SRZASNMS
     C                   ENDIF

     C                   IF        *IN28 = *OFF and *IN29 = *OFF and
     C                             *IN30 = *OFF and *IN31 = *OFF and
     C                             *IN32 = *OFF and *IN33 = *OFF and
     C                             *IN34 = *OFF and *IN35 = *OFF
     C                   EVAL      ValidAll = 'Y'
     C                   EVAL      T1BRCA = #1BRCA
     C                   EVAL      T1MNTH = #1MNTH
     C                   EVAL      T1YEAR = #1YEAR
     C                   EVAL      T1TRID = #1TRID
     C                   EVAL      T1AMNT = #1AMNT
     C                   EVAL      T1RTRN = #1RTRN
     C                   EVAL      T1PTID = #1PTID
     C                   EVAL      T1CNAM = #1CNAM
     C                   EVAL      T1PHON = #1PHON
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Populate Audit File                                 *
      *                                                               *
      *****************************************************************

     C     SRAudit       BEGSR

     C                   IF        #1BRCA = *BLANKS
     C                   EVAL      #1BRCA = 'ALL'
     C                   ENDIF

      ** Form Start and End date

     C                   EVAL      WSTR = '01'
     C                   EVAL      XCNT = 0
     C                   EVAL      XCNT = %LOOKUP(#1MNTH:MOSNUM)
     C                   IF        XCNT > 0
     C                   EVAL      WEND = ENDDAY(XCNT)
     C                   IF        XCNT = 2
     C                   IF        %REM(%DEC(#1YEAR:4:0):4) = 0
     C                   EVAL      WEND = '29'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   MOVE      #1YEAR        ZWYYYY
     C                   MOVE      #1MNTH        ZWMTH
     C                   MOVE      WSTR          ZWDAY
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      SJRDNB = DaynoOut

     C                   MOVE      WEND          ZWDAY
     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   EVAL      EJRDNB = DaynoOut

     C/exec sql
     C+ Select * into :REM123 from RE123ATD where
     C+ MMNREQ = :#1MNTH and MYRREQ = :#1YEAR and MMBRCH = :#1BRCA
     C/end-exec

     C                   IF        SQLCOD = 0
     C/exec sql
     C+ update RE123ATD
     C+ set MMTYPE = '123',
     C+     MDTREQ = :BJRDNB,
     C+     MSDATE = :SJRDNB,
     C+     MEDATE = :EJRDNB,
     C+     MCTRTN = :#1RTRN,
     C+     MTOINT = 0,
     C+     MTRTID = :#1TRID,
     C+     MPTRID = :#1PTID,
     C+     MAPTRN = :WSVAM,
     C+     MCPRSN = :#1CNAM,
     C+     MCPHON = :#1PHON
     C+ where MMNREQ = :#1MNTH and MYRREQ = :#1YEAR and MMBRCH = :#1BRCA
     C/end-exec

     C                   ELSE
     C/exec SQL
     C+ insert into RE123ATD
     C+ (
     C+     MMBRCH,
     C+     MMTYPE,
     C+     MMNREQ,
     C+     MYRREQ,
     C+     MDTREQ,
     C+     MSDATE,
     C+     MEDATE,
     C+     MCTRTN,
     C+     MTOINT,
     C+     MTRTID,
     C+     MPTRID,
     C+     MAPTRN,
     C+     MCPRSN,
     C+     MCPHON
     C+ )
     C+ Values
     C+ (
     C+     :#1BRCA,
     C+     '123',
     C+     :#1MNTH,
     C+     :#1YEAR,
     C+     :BJRDNB,
     C+     :SJRDNB,
     C+     :EJRDNB,
     C+     :#1RTRN,
     C+     0,
     C+     :#1TRID,
     C+     :#1PTID,
     C+     0,
     C+     :#1CNAM,
     C+     :#1PHON
     C+ )
     C/end-exec
     C                   ENDIF

     C                   EVAL      PBranch = #1BRCA
     C                   EVAL      PMonth = #1MNTH
     C                   EVAL      PYear = #1YEAR
     C                   EVAL      PCompFlag = #1RTRN
     C                   EVAL      PFiller = *BLANKS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************

     C     SRZasnms      BEGSR

     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************

     C     SREnd         BEGSR

      ** If selection mode and F3 has been pressed
      ** Terminate program

     C                   EVAL      *INLR = *ON

      ** Exit program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Receive entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAct
     C                   PARM                    PCmd

     C     PPAR1         PLIST
     C                   PARM      *BLANKS       ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE000006'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA


     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C/exec sql
     C+ select * into :SDBANK from SDBANKPD
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'RE000006'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/exec sql
     C+ select * into :SDCURR from SDCURRPD
     C+ where A6CYCD = :BJLCCY
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'RE000006'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALLB     'ZDATE9'
     C                   PARM                    BJRDNB
     C                   PARM                    WDateOut
     C                   PARM                    WRtrn

     C                   MOVE      WYR           NumYrTimstmp
     C                   MOVE      NumYrTimstmp  TChrYr2
     C                   EVAL      TMMDDYY = WMM + WDD + TChrYr2
     C                   EVAL      WTmStmDate = %DATE(TMMDDYY:*MDY0)

      ** Retrieve System Value

     C                   EVAL      PSVK01 = 'LocalAuthContactName'
     C                   EVAL      PSVK02 = 'LocalAuthContactPhon'
     C                   EVAL      PSVK03 = 'LocalAuthTaxBranch'
     C                   EVAL      PSVK04 = 'WhtExtrRetention'

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRTCd
     C                   PARM                    PSVK01
     C                   PARM                    PSVL01
     C                   PARM                    PSVK02
     C                   PARM                    PSVL02
     C                   PARM                    PSVK03
     C                   PARM                    PSVL03
     C                   PARM                    PSVK04
     C                   PARM                    PSVL04
     C                   PARM                    PSVK05
     C                   PARM                    PSVL05
     C                   PARM                    PSVK06
     C                   PARM                    PSVL06
     C                   PARM                    PSVK07
     C                   PARM                    PSVL07
     C                   PARM                    PSVK08
     C                   PARM                    PSVL08
     C                   PARM                    PSVK09
     C                   PARM                    PSVL09
     C                   PARM                    PSVK10
     C                   PARM                    PSVL10

     C                   IF        PRTCD <> *BLANKS
     C                   IF        PSVL01 = '*NRF'
     C                   EVAL      DBKEY = PSVK01
     C                   ENDIF

     C                   IF        PSVL02 = '*NRF'
     C                   EVAL      DBKEY = PSVK02
     C                   ENDIF

     C                   IF        PSVL03 = '*NRF'
     C                   EVAL      DBKEY = PSVK03
     C                   ENDIF

     C                   IF        PSVL04 = '*NRF'
     C                   EVAL      DBKEY = PSVK04
     C                   ENDIF

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBPGM  = 'RE000006'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Open files for update

     C                   OPEN      RE000006DF

     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser
     C                   EVAL      WCDPL = A6NBDP


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
** CPY@
(c) Misys International Banking Systems Ltd. 2013
** MOSNUM
01
02
03
04
05
06
07
08
09
10
11
12
** ENDDAY
31
28
31
30
31
30
31
31
30
31
30
31
