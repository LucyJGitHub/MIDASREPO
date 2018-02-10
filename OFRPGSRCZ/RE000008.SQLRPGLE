     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RE000008 - Midas OF Modelo 193 Request Screen                *
      *                                                               *
      *  Function:  This program allow users to request for Modelo    *
      *               193 report                                      *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034330           Date 07May15               *
      *                 CRE104  *CREATE    Date 04Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034330 - Cancelled 193 request on the Modelo 193 screen is *
      *             saved on the audit file.                          *
      *  CRE104 - Modelo 123 and 193 Reports                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¶ F-specs                              ¶
      ** ¶ =======                              ¶
      ** +--------------------------------------+

      ** Modelo 193 Request Screen Display
     FRE000008DFCF   E             WORKSTN USROPN
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

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Midas Branch Codes File
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC@      E                     EXTFLD(QQDFAC)

      ** External DS for Country details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

     D DSSDY         E DS                  EXTNAME(DSSDY)

     D RE193         E DS                  EXTNAME(RE193ATD)

      ** Rundate data area
     D RUNDAT          DS
     D  WSUC                  11     11
     D  WMBIN                 13     13
      *
      ** Validate Year
     D WDATEYEAR       DS
     D  WDATEMM                1      2    INZ('01')
     D  WDATEDD                3      4    INZ('01')
     D  WDATEYY                5      8

      ** Current Year
     D  EXTYY          S              4S 0
      *
      ** Parameters for ZDATE11
     D W@DateIn        S              8A
     D W@DayNo         S              5P 0
     D W@DFmnt         S              1A
     D W@EFlag         S              1A

      ** Data structure for ZDATE10
     D                 DS
     D  ZZDTIN                 1      8  0
     D  ZWYYYY                 1      4  0
     D  ZWMTH                  5      6  0
     D  ZWDAY                  7      8  0

      ** Data structure for Output parameter
     D POutflds        DS           100
     D  PBranch                1      3A
     D  PYear                  4      7A
     D  PCompFlag              8      8A
     D  PFiller                9    100A

      ** Parameters for ZDATE10
     D DateIn          S                   LIKE(ZZDTIN)
     D DaynoOut        S              5P 0

      ** +--------------------------------------+
      ** ¶ Declared variables                   ¶
      ** ¶ ==================                   ¶
      ** +--------------------------------------+

     D ALLOW           C                   '0123456789'

     D ALLOW2          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ +
     D                                      abcdefghijklmnopqrstuvwxyz—Ò«Á'

     D @RUN            S              1A
     D StartDate       S              5S 0
     D EndDate         S              5S 0
     D WKYEAR          S              2S 0

      ** Database error workfields
     D PRTCD           S              7A
     D POPTN           S              7A

      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ('GBREUSRMSG')
     D PZMsgID         S             10A
     D PZMsgDta        S             45A

      ** General workfields
     D @PRTCD          S              7A
     D ValidAll        S              1A
     D WARNING         S              1A
     D PASVAR          S              1A
     D V1TRID          S             13S 0
     D V1PTID          S             13S 0
     D V1CONT          S              9S 0

     D LBRANCH         S              3A
     D LPERSON         S             40A
     D LPHONE          S              9A
     D LRETEN          S              2S 0
     D VARYEAR         S              4S 0
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A

      ** System Values details
     D PSysVal1        C                   CONST('LocalAuthTaxBranch')
     D PSysVal2        C                   CONST('LocalAuthContactName')
     D PSysVal3        C                   CONST('LocalAuthContactPhon')
     D PSysVal4        C                   CONST('WhtExtrRetention')
      *
      ** Parameter variables for AOSVALR0 string
     D SVALK1          S             20
     D SVAL1           S            200
     D SVALK2          S             20
     D SVAL2           S            200
     D SVALK3          S             20
     D SVAL3           S            200
     D SVALK4          S             20
     D SVAL4           S            200
     D SVALK5          S             20
     D SVAL5           S            200
     D SVALK6          S             20
     D SVAL6           S            200
     D SVALK7          S             20
     D SVAL7           S            200
     D SVALK8          S             20
     D SVAL8           S            200
     D SVALK9          S             20
     D SVAL9           S            200
     D SVALK0          S             20
     D SVAL10          S            200

      ** AOBRCHR1 parameters
     D SRTCD           S              7A
     D SOPTN           S              7A
     D SPFTC           S              3A

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

     C/exec SQL                                                                             MD034330
     C+ set option commit = *CHG                                                            MD034330
     C/end-exec                                                                             MD034330

      ** Clear Fields

     C                   EXSR      SRClear

     C                   DOW       ValidAll = 'N' and *IN03 = *Off

      ** Display Screen

     C                   TIME                    #1TIME
     C                   WRITE     RE000008C1
     C                   WRITE     RE000008F2
     C                   EXFMT     RE000008F1

     C                   IF        WARNING = 'Y' AND ValidAll = 'Y' AND
     C                             *IN03 = *OFF
     C                   EXSR      SRProcess
     C                   LEAVE
     C                   ENDIF

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

      ** Validate Fields

     C                   MOVEA     '0000000'     *IN(30)

     C                   EVAL      *IN40 = *OFF

     C                   EXSR      SRValidate

     C                   IF        *IN40 = *OFF AND *IN03 = *OFF
     C                   EVAL      ValidAll = 'Y'
     C                   EXSR      SRProcess
     C                   ENDIF

     C                   ENDDO

     C                   EXSR      SREnd

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClear - Clear screen fields                                 *
      *                                                               *
      *****************************************************************

     C     SRClear       BEGSR

     C                   EVAL      ValidAll = 'N'
     C                   EVAL      #1BRCA = *BLANKS
     C                   EVAL      #1YEAR = *BLANKS
     C                   EVAL      #1TRID = *BLANKS
     C                   EVAL      #1PTID = *BLANKS
     C                   EVAL      #1RTRN = *BLANKS
     C                   EVAL      #1CONP = *BLANKS
     C                   EVAL      #1CONT = *BLANKS
     C                   EVAL      WARNING = 'N'
     C                   EVAL      PASVAR  = 'N'

     C                   EVAL      V1TRID  = *ZEROS
     C                   EVAL      V1PTID  = *ZEROS
     C                   EVAL      V1CONT  = *ZEROS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Screen Fields                           *
      *                                                               *
      *****************************************************************

     C     SRValidate    BEGSR
      *
      ** Validate Branch
      *
     C                   IF        #1BRCA <> *BLANKS

     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       SRTCD
     C                   PARM      '*KEY    '    SOPTN
     C                   PARM      #1BRCA        SPFTC
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        SRTCD <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'RE77134'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1BRCA = A8BRCD
     C                   MOVE      #1BRCA        XBRANCH           3
     C                   ENDIF

     C                   ELSE
     C                   IF        LBRANCH = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'RE77140'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   MOVE      'ALL'         XBRANCH           3
     C                   ENDIF
     C                   ENDIF

     C                   IF        #1BRCA <> *BLANKS

     C/exec sql
     C+ select * into :SDCUST from SDCUSTPD
     C+ where BBCUST = :A8BICN
     C/end-exec

     C                   IF        SQLCOD = 0

     C/exec sql
     C+ select * into :SDCTRY from SDCTRYPD
     C+ where A4CNCD = :BBCOLC
     C/end-exec
     C                   IF        SQLCOD <> 0 OR
     C                             A4ISOC <> 'ES'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN30 = *ON
     C                   EVAL      PZMsgID = 'RE77139'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Year
      *
     C                   IF        #1YEAR <> *BLANKS
     C                   MOVEL     #1YEAR        WDATEYY
     C                   CALL      'ZDATE11'
     C                   PARM      WDATEYEAR     W@DateIn
     C                   PARM      *ZERO         W@DayNo
     C                   PARM      'D'           W@DFmnt
     C                   PARM      *BLANKS       W@EFlag

     C                   IF        W@EFlag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WARNING = 'N'
     C                   EVAL      PZMsgID = 'RE77131'
     C                   EXSR      SRZasnms

     C                   ELSE
     C                   MOVE      #1YEAR        VARYEAR
     C                   IF        (EXTYY - VARYEAR) > LRETEN
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PZMsgID = 'RE77141'
     C                   EVAL      WARNING = 'N'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   IF        #1YEAR = *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PZMsgID = 'RE77131'
     C                   EVAL      WARNING = 'N'
     C                   EXSR      SRZasnms

     C                   ELSE
     C                   IF        #1YEAR >= %CHAR(EXTYY)
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WARNING = 'N'
     C                   EVAL      PZMsgID = 'RE77131'
     C                   EXSR      SRZasnms

     C                   ELSE

     C                   IF        WARNING = 'N'

     C/EXEC SQL
     C+ Select * into :RE193 from RE193ATD
     C+    Where NYRREQ = :#1YEAR and NTBRCA = :XBRANCH
     C/END-EXEC

     C                   IF        SQLCode = 0
     C                   EVAL      WARNING = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      PZMsgID = 'RE77129'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Tax Return Identifier
      *
     C                   IF        #1TRID <> *BLANKS

     C                   SELECT
     C                   WHEN      %CHECK(ALLOW:%TRIM(#1TRID)) > 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PZMsgID = 'RE77133'
     C                   EXSR      SRZasnms

     C                   WHEN      %LEN(%TRIM(#1TRID)) < 13
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PZMsgID = 'RE77133'
     C                   EXSR      SRZasnms

     C                   WHEN      %SUBST(#1TRID:1:3) <> '193'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PZMsgID = 'RE77130'
     C                   EXSR      SRZasnms

     C                   ENDSL

     C                   ENDIF
      *
      ** Validate Previous Tax Return Identifier
      *
     C                   IF        #1PTID <> *BLANKS

     C                   SELECT
     C                   WHEN      %CHECK(ALLOW:%TRIM(#1PTID)) > 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PZMsgID = 'RE77133'
     C                   EXSR      SRZasnms

     C                   WHEN      %LEN(%TRIM(#1PTID)) < 13
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PZMsgID = 'RE77133'
     C                   EXSR      SRZasnms

     C                   WHEN      %SUBST(#1PTID:1:3) <> '193'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PZMsgID = 'RE77130'
     C                   EXSR      SRZasnms
     C                   ENDSL

     C                   ENDIF
      *
      ** Validate Replacement Tax Return Flag
      *
     C                   IF        #1RTRN = *BLANK
     C                   EVAL      *IN40 = *ON
     C                   ENDIF

     C                   IF        #1RTRN <> 'Y' AND #1RTRN <> 'N' AND
     C                             #1RTRN <> *BLANK
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PZMsgID = 'RE77126'
     C                   EXSR      SRZasnms
     C                   ELSE

     C/EXEC SQL
     C+ Select * into :RE193 from RE193ATD
     C+    Where NYRREQ = :#1YEAR and NTBRCA = :XBRANCH
     C/END-EXEC

     C                   IF        SQLCode = 0 AND PASVAR = 'N'
     C                   EVAL      PASVAR = 'Y'
     C                   EVAL      #1RTRN = 'Y'

     C                   IF        NTRTID <> *ZEROS
     C                   EVAL      #1PTID = %TRIM(%CHAR(NTRTID))
     C                   ENDIF

     C                   ELSE
     C                   IF        #1RTRN <> 'Y'
     C                   EVAL      #1RTRN = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   IF        #1PTID = *BLANKS AND #1RTRN = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN33 = *ON
     C                   EVAL      PZMsgID = 'RE77128'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   IF        #1RTRN = 'N' and
     C                             #1PTID <> *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      PZMsgID = 'RE77142'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      ** Validate Contact Person
      *
     C                   IF        #1CONP = *Blanks and LPERSON = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN35 = *ON
     C                   EVAL      PZMsgID = 'RE77137'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   IF        #1CONP = *BLANKS
     C                   EVAL      #1CONP = LPERSON
     C                   EVAL      *IN40  = *ON

     C                   ELSE
     C                   IF        %CHECK(ALLOW2:%TRIM(#1CONP)) > 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN35 = *ON
     C                   EVAL      PZMsgID = 'RE77143'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Contact Telephone
      *
     C                   IF        #1CONT = *Blanks and LPHONE = *Blanks
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      PZMsgID = 'RE77138'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   IF        #1CONT = *BLANKS
     C                   EVAL      #1CONT = LPHONE
     C                   EVAL      *IN40  = *ON

     C                   ELSE
     C                   IF        %CHECK(ALLOW:%TRIM(#1CONT)) > 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      PZMsgID = 'RE77144'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   IF        %LEN(%TRIM(#1CONT)) < 9
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      PZMsgID = 'RE77144'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process report                                    *
      *                                                               *
      *****************************************************************

     C     SRProcess     BEGSR

     C                   IF        #1BRCA = *BLANKS
     C                   EVAL      #1BRCA = 'ALL'
     C                   ENDIF

     C                   MOVE      #1YEAR        ZWYYYY
     C                   Z-ADD     1             ZWMTH
     C                   Z-ADD     1             ZWDAY
     C                   EXSR      SRConvert
     C                   EVAL      StartDate = DaynoOut

     C                   MOVE      #1YEAR        ZWYYYY
     C                   Z-ADD     12            ZWMTH
     C                   Z-ADD     31            ZWDAY
     C                   EXSR      SRConvert
     C                   EVAL      EndDate   = DaynoOut

     C                   IF        #1TRID <> *BLANKS
     C                   EVAL      V1TRID  =  %DEC(#1TRID:13:0)
     C                   ELSE
     C                   EVAL      V1TRID  =  *ZEROS
     C                   ENDIF

     C                   IF        #1PTID <> *BLANKS
     C                   EVAL      V1PTID  =  %DEC(#1PTID:13:0)
     C                   ELSE
     C                   EVAL      V1PTID  =  *ZEROS
     C                   ENDIF

     C                   IF        #1CONT <> *BLANKS
     C                   EVAL      V1CONT  =  %DEC(#1CONT:9:0)
     C                   ELSE
     C                   EVAL      V1CONT  =  *ZEROS
     C                   ENDIF

     C/EXEC SQL
     C+ Select * into :RE193 from RE193ATD
     C+    Where NYRREQ = :#1YEAR and NTBRCA = :#1BRCA
     C/END-EXEC
      *
     C                   IF        SQLCODE = 0

     C/exec SQL
     C+ update RE193ATD
     C+   Set NTBRCA   =  :#1BRCA,
     C+       NMTYPE   =  '193',
     C+       NYRREQ   =  :#1YEAR,
     C+       NDTREQ   =  :BJRDNB,
     C+       NRTRTN   =  :#1RTRN,
     C+       NTRTID   =  :V1TRID,
     C+       NPTRID   =  :V1PTID,
     C+       NSDATE   =  :StartDate,
     C+       NEDATE   =  :EndDate,
     C+       NCPERS   =  :#1CONP,
     C+       NCTELP   =  :V1CONT
     C+   Where NYRREQ = :#1YEAR and NTBRCA = :#1BRCA
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ insert into RE193ATD
     C+ (
     C+       NTBRCA,
     C+       NMTYPE,
     C+       NYRREQ,
     C+       NDTREQ,
     C+       NRTRTN,
     C+       NTRTID,
     C+       NPTRID,
     C+       NSDATE,
     C+       NEDATE,
     C+       NCPERS,
     C+       NCTELP
     C+ )
     C+ Values
     C+ (
     C+       :#1BRCA,
     C+       '193',
     C+       :#1YEAR,
     C+       :BJRDNB,
     C+       :#1RTRN,
     C+       :V1TRID,
     C+       :V1PTID,
     C+       :StartDate,
     C+       :EndDate,
     C+       :#1CONP,
     C+       :V1CONT
     C+ )
     C/end-exec
     C                   ENDIF

     C                   EVAL      PBranch = #1BRCA
     C                   EVAL      PYear =  #1YEAR
     C                   EVAL      PCompFlag = #1RTRN
     C                   EVAL      PFiller = *Blanks

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
      *
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
      * SRConvert - Convert YYYYMMDD to Midas Date                    *
      *                                                               *
      *****************************************************************

     C     SRConvert     BEGSR

     C                   CALL      'ZDATE10'
     C                   PARM      ZZDTIN        DateIn
     C                   PARM      *ZEROS        DaynoOut

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCountry - Check if Spanish Branch                           *
      *                                                               *
      *****************************************************************

     C     SRCountry     BEGSR


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


      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'RE000008'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA


     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Retrieve the system value

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       @PRTCD
     C                   PARM      PSysVal1      SVALK1
     C                   PARM      *BLANKS       SVAL1
     C                   PARM      PSysVal2      SVALK2
     C                   PARM      *BLANKS       SVAL2
     C                   PARM      PSysVal3      SVALK3
     C                   PARM      *BLANKS       SVAL3
     C                   PARM      PSysVal4      SVALK4
     C                   PARM      *BLANKS       SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10

      ** If the system values are not found then issue a database error

     C     @PRTCD        IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CLEAR                   LBRANCH
     C                   CLEAR                   LPERSON
     C                   CLEAR                   LPHONE
     C                   Z-ADD     *ZEROS        LRETEN
     C                   EVAL      LBRANCH  =  SVAL1
     C                   EVAL      LPERSON  =  SVAL2
     C                   EVAL      LPHONE   =  SVAL3
     C                   MOVEL     SVAL4         LRETEN

     C/exec sql
     C+ select * into :SDBANK from SDBANKPD
     C/end-exec

     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'RE000008'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Open files for update

     C                   OPEN      RE000008DF


     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser

     C                   Z-ADD     *ZEROS        VARYEAR
     C                   Z-ADD     *ZEROS        WKYEAR
     C                   MOVE      BJMRDT        WKYEAR
     C                   EVAL      EXTYY  =  2000 + WKYEAR

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

