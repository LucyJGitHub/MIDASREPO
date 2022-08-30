     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058085
/*STD *  RPGSQLMOD                                                    *                     MD058085
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058085
/*EXI *  TEXT('Midas SD Watch list configuration update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDWLCCUPD - Watch List Configuration Update                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDCWCDPD  UF   E             DISK    COMMIT
      ** Watch List Configuration Data File

     F*SDWLCCL1* UF   E           K DISK    COMMIT                                          MD058085
      ** Watch List Checking Details by Function Code

     F*SDWLMTL1* UF A E           K DISK    COMMIT                                          MD058085
      ** Watch List Checking Details by Message Type

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D ValidWLCM     E DS                  EXTNAME(SDWLCMPD)
      ** Valid Watch List Configuration Definition File

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger ICD

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure

     D SDWLMT        E DS                  EXTNAME(SDWLTJW0)                                MD058085
     D SDWLCC        E DS                  EXTNAME(SDWLCJW0)                                MD058085
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D A               S              3P 0
     D B               S              3P 0
     D C               S              3P 0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PINKH           S              1A
     D ZFREQ           S              1A
     D ZCCY            S              3A
     D ZLOC            S              3A                                                    AR702741
     D ZDAYNO          S              5P 0
     D ZMDAY           S              2P 0
     D TempPFRQ        S              1A
     D TempPDYN        S              2P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Body                                              *
      *                                                               *
      *****************************************************************

      ** Amend file

     C                   EXSR      SRAMEND

     C                   RETURN

      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRAMEND - Amend File                                         *
      *                                                              *
      ****************************************************************

     C     SRAMEND       BEGSR

     C                   IF        PINKH = *ON

     C     1             SETLL     SDCWCDPD
     C                   READ      SDCWCDPD                               75

     C                   EVAL      W1LUDT = BJRDNB

      ** Update record

     C                   UPDATE    SDCWCDD0

     C                   ELSE

      ** Access file

     C*****#1FUNC        CHAIN     SDWLCCL1                           75                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDWLCC                                                                        MD058085
     C+ from SDWLCJW0                                                                       MD058085
     C+ where W1FUNC = :#1FUNC                                                              MD058085
     C/END-EXEC                                                                             MD058085

      ** Database error

     C**********         IF        *IN75 = *ON                                              MD058085
     C                   IF        SQLCODE = 100                                            MD058085
     C                   EVAL      DBKEY  = #1FUNC
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      SRERR
     C                   ENDIF

     C                   EVAL      W1FUNC = #1FUNC
     C                   EVAL      W1FUND = #1FUND
     C                   EVAL      W1EWLC = #1EWLC
     C                   EVAL      TempPFRQ = W1PFRQ
     C                   EVAL      TempPDYN = W1PDYN
     C                   EVAL      W1PFRQ = #1PFRQ
     C                   MOVE      #1PDYN        W1PDYN

     C                   IF        TempPFRQ <> W1PFRQ or TempPDYN <> W1PDYN

     C                   IF        #1PFRQ <> *BLANKS

     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      #1PFRQ        ZFREQ
     C                   PARM      BJRDNB        ZDAYNO
     C                   PARM      BJLCCY        ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM      W1PDYN        ZMDAY
     C                   PARM                    BJDFIN
     C     SDGELR        PARM      SDGELR        DSFDY

     C                   IF        PRTCD = *BLANKS
     C                   EVAL      W1NPCD = ZDAYNO
     C                   ELSE
     C                   MOVE      ZDAYNO        DBKEY
     C                   EVAL      DBFILE = 'ZFREQB'
     C                   EVAL      DBASE  = 902
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   IF        W1FUNC = 'MESSGENT'
     C                   EVAL      W1PFRQ = *BLANKS
     C                   ENDIF

      ** Update record

     C**********         UPDATE    SDWLCCD0                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ update SDWLCXTD set                                                                 MD058085
     C+   W1FUND = :W1FUND                                                                  MD058085
     C+ , W1EWLC = :W1EWLC                                                                  MD058085
     C+ , W1PFRQ = :W1PFRQ                                                                  MD058085
     C+ , W1PDYN = :W1PDYN                                                                  MD058085
     C+ , W1NPCD = :W1NPCD                                                                  MD058085
     C+ , W1LPCD = :W1LPCD                                                                  MD058085
     C+ , W1LCD  = :W1LCD                                                                   MD058085
     C+ , W1TYLC = :W1TYLC                                                                  MD058085
     C+ where W1FUNC = :W1FUNC                                                              MD058085
     C/END-EXEC                                                                             MD058085

     C                   IF        W1FUNC = 'MESSGENT'

      ** Delete records

     C******LOVAL        SETLL     SDWLMTL1                                                 MD058085
     C**********         READ      SDWLMTL1                                                 MD058085
     C**********         DOW       NOT %EOF                                                 MD058085
     C**********         DELETE    SDWLMTL1                                                 MD058085
     C**********         READ      SDWLMTL1                                                 MD058085
     C**********         ENDDO                                                              MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDWLTCTD                                                                MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDWLTBTD                                                                MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ delete from SDWLTXTD                                                                MD058085
     C/END-EXEC                                                                             MD058085

     C                   EVAL      A = 1
     C                   EVAL      B = 53
     C                   EVAL      C = 56

     C                   DOW       A <= 20
     C                   EVAL      W2MTYP = (%SUBST(ValidWLCM:B:3))
     C                   EVAL      W2INEX = (%SUBST(ValidWLCM:C:1))

     C                   IF        W2MTYP <> *BLANKS
     C**********         WRITE     SDWLMTD0                                                 MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDWLTBTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   W2MTYP                                                                            MD058085
     C+  ,W2INEX                                                                            MD058085
     C+  ,W2MODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :W2MTYP                                                                           MD058085
     C+  ,:W2INEX                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C/EXEC SQL                                                                             MD058085
     C+ insert into SDWLTXTD                                                                MD058085
     C+ (                                                                                   MD058085
     C+   W2MTYP                                                                            MD058085
     C+  ,W2INEX                                                                            MD058085
     C+  ,W2MODE                                                                            MD058085
     C+ )                                                                                   MD058085
     C+ Values                                                                              MD058085
     C+ (                                                                                   MD058085
     C+   :W2MTYP                                                                           MD058085
     C+  ,:W2INEX                                                                           MD058085
     C+  ,'B'                                                                               MD058085
     C+ )                                                                                   MD058085
     C/END-EXEC                                                                             MD058085
     C                   ENDIF

     C                   EVAL      A = A + 1
     C                   EVAL      B = B + 4
     C                   EVAL      C = C + 4
     C                   ENDDO

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR


      ** Program Parameters

     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    PRTCD
      ** F8 Key
     C                   PARM                    PINKH
      ** Valid Watch List Configuration Definition File
     C                   PARM                    ValidWLCM

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      SRERR
     C                   ENDIF

     C                   ENDSR

      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRERR - Exception Errors                                     *
      *                                                              *
      ****************************************************************

     C     SRERR         BEGSR

     C                   MOVEL     '*ERROR '     PRTCD
     C                   MOVEL     'SDWLCCUPD'   DBPGM
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP

      ** Terminate the program

     C                   RETURN

     C                   ENDSR

      ****************************************************************
