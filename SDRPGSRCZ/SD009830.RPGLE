     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Account Transfer Type/Sub-Type')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009830 - SD Account Transfer Type/Sub-Type                 *
      *                                                               *
      *  Function:  This module will report all the Account Transfer  *
      *             Type/Sub-Type SDATSTPD.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. MD035317           Date 25May16               *
      *  Prev Amend No. BUG27774           Date 16Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204A            Date 08Mar10               *
      *                 CAP204  *CREATE    Date 11Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035317 - Wrong audit trail report for Account Transfer     *
      *             Sub-type maintenance. Use fields for credit       *
      *             account details.                                  *
      *  BUG27774 - SDC0602 00001                                     *
      *  CAP204A - Teller Related APIs - Account Transfer: Change     *
      *            Request 027 - Add new field Wash Account Code      *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDATSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Margin Schedule Type Retrieval Index

     FSDFCTLL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Standing Data Controls File Retrieval Index

     FSD009830P1O    E             PRINTER INFDS(SPOOL1) USROPN INFSR(*PSSR)
      ** Midas SD Margin Schedule Type Details Printer File - Details

     FSD009830AUO    E             PRINTER INFDS(SPOOLU) USROPN INFSR(*PSSR)
      ** Midas SD Margin Schedule Type Details Printer File - Audit

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File Information Data Structure for SD009830P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0

      ** File Information Data Structure for SD009830AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameter list fields
     D PMODE           S              1
     D PLEVL           S              1
     D PENTY           S              3

      ** Parameters for ZSFILE
     D PSEQ            S              5
     D PSFILE          S             10
     D PZSNUM          S              6  0
     D PZSERR          S              1

      ** Parameters for ZDATE2
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A

      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7

      ** Other fields used
     D WRUN            S              1
     D WFIRST          S              1    INZ('Y')
     D WFNAME          S             10
     D WNOREC          S              5  0 INZ(0)
     D RQDLN1          S              3  0
     D DIFLN1          S              3  0

      ** Temporary Fields
     D WDCODE          S             10A
     D WDCSEQ          S              2A
     D WCCODE          S             10A
     D WCCSEQ          S              2A
     D WACCOD          S             10S 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C     *LOVAL        SETLL     SDATSTL0
     C                   READ      SDATSTL0

      ** Print Audit Report if file is empty

     C                   IF        %EOF(SDATSTL0)
     C                   EXSR      SRAUDIT
     C                   ENDIF

     C                   DOW       NOT %EOF(SDATSTL0)

      ** Count no. of records processed

     C                   EVAL      WNOREC = WNOREC + 1

      ** Process Report Lines

     C                   EXSR      SRPRINT

      ** Read next record

     C                   READ      SDATSTL0

     C                   ENDDO

     C                   EXSR      SREND

      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRINT - Print details report                                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZSFILE, ZDATE2                                         *
      *                                                               *
      *****************************************************************
     C     SRPRINT       BEGSR

     C                   IF        NOT %OPEN(SD009830P1)
     C                   OPEN      SD009830P1

      ** Ensure Detail Spool File recorded by RCF

     C                   EVAL      PZSNUM = SFNUM1

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PENTY
     C                   PARM      SFILE1        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program

     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   ENDIF

     C                   EVAL      RQDLN1 = 1
     C                   EVAL      PRTLN1 = 59
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1

     C                   IF        DIFLN1 <= RQDLN1 OR
     C                             WFIRST = 'Y'
     C                   WRITE     HEADER
     C                   EVAL      WFIRST = 'N'
     C                   ENDIF

      ** Write details to printer fields
      ** Transfer Type/SubType

     C                   EVAL      RTTRTY = ATTRTY
     C                   EVAL      RTTRDS = ' '
     C                   EVAL      RTTRST = ATTRST
     C                   EVAL      RTTRSD = ATTRSD

      ** Debit account details

     C                   MOVE      ATDBAC        WDCODE
     C                   MOVE      ATDBSQ        WDCSEQ

     C                   EVAL      RDEBAC = ATDBBR + ATDBCU + ATDBCY +
     C                                      WDCODE + WDCSEQ
     C                   EVAL      RTDBRT = ATDBRT
     C                   MOVEL     ATDBVD        RTDBVD
     C                   EVAL      RTDBVS = ATDBVS

      ** Credit account details

     C**********         MOVE      ATDBAC        WCCODE                                     MD035317
     C**********         MOVE      ATDBSQ        WCCSEQ                                     MD035317
     C                   MOVE      ATCRAC        WCCODE                                     MD035317
     C                   MOVE      ATCRSQ        WCCSEQ                                     MD035317

     C                   EVAL      RCREAC = ATCRBR + ATCRCU + ATCRCY +
     C                                      WCCODE + WCCSEQ
     C                   EVAL      RTCRRT = ATCRRT
     C                   MOVEL     ATCRVD        RTCRVD
     C                   EVAL      RTCRVS = ATCRVS
                                                                                             CAP204A
      ** Wash Account Code                                                                   CAP204A
                                                                                             CAP204A
     C                   MOVEL     ATWACC        RTWACC                                      CAP204A

      ** Statement Extended Narrative

     C                   EVAL      RTSNAR = ATSNAR
     C                   EVAL      RTEXT1 = ATEXT1
     C                   EVAL      RTEXT2 = ATEXT2
     C                   EVAL      RTEXT3 = ATEXT3
     C                   EVAL      RTEXT4 = ATEXT4
     C                   EVAL      RTEXT5 = ATEXT5
     C                   EVAL      RTEXT6 = ATEXT6

      ** Fee details
      ** Print only non-blank lines of fee details
      ** Fee 1

     C                   IF        ATF1DS <> *BLANKS
     C                   EVAL      RTF1DS = ATF1DS
     C                   EVAL      WACCOD = ATF1CD
     C                   MOVEL     WACCOD        RTF1CD
     C                   EVAL      RTF1ST = ATF1ST
     C                   EVAL      *IN01 = *ON
     C                   ENDIF

      ** Fee 2

     C                   IF        ATF2DS <> *BLANKS
     C                   EVAL      RTF2DS = ATF2DS
     C                   EVAL      WACCOD = ATF2CD
     C                   MOVEL     WACCOD        RTF2CD
     C                   EVAL      RTF2ST = ATF2ST
     C                   EVAL      *IN02 = *ON
     C                   ENDIF

      ** Fee 3

     C                   IF        ATF3DS <> *BLANKS
     C                   EVAL      RTF3DS = ATF3DS
     C                   EVAL      WACCOD = ATF3CD
     C                   MOVEL     WACCOD        RTF3CD
     C                   EVAL      RTF3ST = ATF3ST
     C                   EVAL      *IN03 = *ON
     C                   ENDIF

      ** Fee 4

     C                   IF        ATF4DS <> *BLANKS
     C                   EVAL      RTF4DS = ATF4DS
     C                   EVAL      WACCOD = ATF4CD
     C                   MOVEL     WACCOD        RTF4CD
     C                   EVAL      RTF4ST = ATF4ST
     C                   EVAL      *IN04 = *ON
     C                   ENDIF

      ** Fee 5

     C                   IF        ATF5DS <> *BLANKS
     C                   EVAL      RTF5DS = ATF5DS
     C                   EVAL      WACCOD = ATF5CD
     C                   MOVEL     WACCOD        RTF5CD
     C                   EVAL      RTF5ST = ATF5ST
     C                   EVAL      *IN05 = *ON
     C                   ENDIF

      ** Fee 6

     C                   IF        ATF6DS <> *BLANKS
     C                   EVAL      RTF6DS = ATF6DS
     C                   EVAL      WACCOD = ATF6CD
     C                   MOVEL     WACCOD        RTF6CD
     C                   EVAL      RTF6ST = ATF6ST
     C                   EVAL      *IN06 = *ON
     C                   ENDIF

      ** Insert, Authorise and Approve User

     C                   EVAL      RTIUSR = ATUSER
     C                   EVAL      RTAUSR = ATAUTH
     C                   EVAL      RTAPUS = ATAPRV

      ** Last Change Date/Type

     C                   SELECT
     C                   WHEN      ATCHTP = 'I'
     C                   EVAL      RTLCTY = 'INSERT'
     C                   WHEN      ATCHTP = 'A'
     C                   EVAL      RTLCTY = 'AMEND'
     C                   WHEN      ATCHTP = 'D'
     C                   EVAL      RTLCTY = 'DELETE'
     C                   END

     C                   EVAL      ZDAYNO = ATLCDT
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE

     C                   IF        ZADATE <> *Blanks
     C                   EVAL      RTLCDT = ZADATE
     C                   ELSE
     C                   EVAL      RTLCDT = *BLANKS
     C                   ENDIF

      ** Write Detail Format

     C                   WRITE     DETAIL

     C                   SETOFF                                       010203
     C                   SETOFF                                       040506

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND - Print trailer report                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRAUDIT                                                *
      *                                                               *
      *****************************************************************

     C     SREND         BEGSR

     C                   EVAL      RQDLN1 = 4
     C                   EVAL      DIFLN1 = OFLLN1 - PRTLN1
     C                   IF        DIFLN1 <= RQDLN1
     C                   WRITE     HEADER
     C                   ENDIF

      ** Write out report trailer

     C                   WRITE     TRAILER

      ** Check control details

     C                   EVAL      WFNAME = 'SDATSTPD'
     C     WFNAME        CHAIN     SDFCTLL1                           55

      ** Database error

     C                   IF        *IN55 = '1'
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WFNAME
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      RINSER = AHNOIN
     C                   EVAL      RAMEND = AHNOAM
     C                   EVAL      RDELET = AHNODL
     C                   EVAL      RAUDIT = AHNORC
     C                   EVAL      RCOUNT = WNoRec

     C                   IF        RCOUNT <> RAUDIT
      *                                                                                     BUG27774
      ** File Out Of Balance - SETON U8                                                     BUG27774
      *                                                                                     BUG27774
     C                   EVAL      *INU8 = *ON                                              BUG27774
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF

      ** Write audit report

     C                   EXSR      SRAUDIT

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDIT - Print audit report                                  *
      *                                                               *
      * Called by: Main Processing, SREND, *PSSR                      *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************

     C     SRAUDIT       BEGSR

     C                   OPEN      SD009830AU

      ** Ensure Audit Spool File recorded by RCF

     C                   EVAL      PZSNUM = SFNUMU

     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PENTY
     C                   PARM      SFILEU        PSFILE
     C                   PARM                    PZSNUM
     C                   PARM      *BLANK        PZSERR

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program

     C                   IF        PZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   WRITE     HEADAU

      ** If there is a DB Error, Output the DB Error Information

     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE

      ** If there is a record read, write audit control report

     C                   IF        WNOREC <> 0
     C                   WRITE     CONTROL
     C                   ELSE

      ** Or, if no records read, Output "No Details" message

     C                   WRITE     NODTLS
     C                   ENDIF

     C                   ENDIF

      ** Close Audit Printer File & Report File

     C                   IF        %OPEN(SD009830P1)
     C                   CLOSE     SD009830P1
     C                   ENDIF

     C                   IF        %OPEN(SD009830AU)
     C                   CLOSE     SD009830AU
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
     C                   PARM                    PSEQ
     C                   PARM                    PLEVL
     C                   PARM                    PENTY

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Initialise Report Work fields

     C                   EVAL      RQDLN1 = 0
     C                   EVAL      DIFLN1 = 0
     C                   EVAL      PRTLN1 = 0

     C                   ENDSR

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
      * Calls: SRAudit                                                *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRUN = *BLANKS
     C                   EVAL      WRUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAUDIT
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
