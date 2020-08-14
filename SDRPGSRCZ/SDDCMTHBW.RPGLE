     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Mgt - Comment History Browse')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDDCMTHBW - Document Mgt Comment History Browse              *
      *                                                               *
      *  Function: This module list all comment history of a          *
      *            Document History Details                           *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CSD093   *CREATE   Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** SD Document Mgt Comment History
     FSDDMCHL0  IF   E           K DISK    INFSR(*PSSR)

      ** SD Document Mgt Comment History Subfile
     FSDDCMTHBDFCF   E             WORKSTN SFILE(SDDCMTHS0:WWRRN)

      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

     D/COPY ZACPYSRC,STDDECLARE

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,ERR_ARRAYS

     D/COPY ZACPYSRC,FVAL_ARRAY

     D/COPY ZACPYSRC,APICTLARR

     D/COPY ZACPYSRC,MSGHNDDCL

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

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for Non-Account Holder Details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Time Format
     D WWCTIM          DS
     D  WWHH                   1      2
     D  WWC1                   3      3    INZ(':')
     D  WWMM                   4      5
     D  WWC2                   6      6    INZ(':')
     D  WWSS                   7      8

      ** Work Variables
     D PKeySts         S              7A
     D PCNum           S             10A
     D DDREFN          S             10A
     D DDRTYP          S              1A
     D DDCODE          S              2A
     D DDNARR          S             30A
     D DDSEQN          S              3A
     D WSEQN           S              3S 0
     D WLOOP           S              1A
     D WkCUSR          S             10A
     D WkCDAT          S              6A
     D WkCTIM          S              6A
     D WkCOMM          S             64A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
     D WWRRN           S              5P 0
     D WWCNT           S              3P 0
     D WWEOF           S              1A
     D WWERR           S              1P 0
     D ZDAYNO          S              5P 0
     D ZDATEX          S              6P 0
     D ZADATE          S              7A
     D LENGTH1         S              3P 0
     D START           S              3P 0
     D LENGTH2         S              3P 0
     D TRANSLATE       S              1A
     D TRIM            S              1A
     D WILD            S              1A
     D RESULT          S              3P 0
     D ZDATE           S              6A
     D SelDATE         S              5P 0
     D SelTIME         S              6A
     D Errorflag       S              1A
     D ZALIGNOK        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0

      ** AO Parameters
     D PNAHO           S             10A
     D PRTCD           S              7A
     D POPTN           S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Build Sub-file

     C                   EVAL      WLOOP = 'Y'

     C                   DOW       WLOOP = 'Y'
     C                   EXSR      BLDSFL
     C                   EVAL      WLOOP = 'Y'
     C                   ENDDO

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE
      *****************************************************************

     C     BLDSFL        BEGSR

      ** Initialise subfile relative record number.

     C                   Z-ADD     0             WWRRN

     C                   EXSR      SRCUST

      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.

     C                   MOVE      '1'           *IN97
     C                   WRITE     SDDCMTHC0
     C                   MOVE      '0'           *IN97

     C                   MOVE      DDCODE        DHCODE
     C                   MOVE      DDNARR        DHNARR
     C                   MOVEL     DDSEQN        WSEQN

      ** Set file pointer on key displayed on screen.

     C     KDMCH         SETGT     SDDMCHL0

      ** Read Document Management Comment history

     C                   EXSR      RDDMCH

      ** set up message 'no data to display'

     C                   EVAL      *IN80 = *OFF
     C                   IF        WWEOF = 'Y' OR
     C                             CHREFN <> DDREFN OR
     C                             CHRTYP <> DDRTYP OR
     C                             CHCODE <> DDCODE OR
     C                             CHSEQN <> WSEQN
     C                   EVAL      *IN80 = *ON
     C                   END

      **  Set on ROLLUP indicator to drive initial loop.

     C                   EVAL      *IN98 = '1'

      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 is input.

     C     *IN98         DOWEQ     '1'
     C     WLOOP         ANDEQ     'Y'

      ** Initialise count of records written to subfile page.

     C                   Z-ADD     0             WWCNT
     C                   IF        WWEOF = 'Y'
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF

      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.

     C                   DOW       WWEOF <> 'Y' AND
     C                             WWCNT < 4 AND
     C                             CHREFN = DDREFN AND
     C                             CHRTYP = DDRTYP AND
     C                             CHCODE = DDCODE AND
     C                             CHSEQN = WSEQN

      ** Increment the subfile record no. and records written fields.

     C                   ADD       1             WWRRN
     C                   ADD       1             WWCNT

      ** Write the customer to the subfile.

     C                   Z-ADD     WWRRN         DDSFRN

     C                   IF        CHCTIM <> *BLANKS
     C                   EVAL      WWHH = %SUBST(CHCTIM:1:2)
     C                   EVAL      WWMM = %SUBST(CHCTIM:3:2)
     C                   EVAL      WWSS = %SUBST(CHCTIM:5:2)
     C                   MOVE      WWCTIM        DDCTIM
     C                   ELSE
     C                   EVAL      DDCTIM = *BLANKS
     C                   ENDIF

     C                   EVAL      DDCUSR = CHCUSR
     C                   MOVE      CHCDAT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVE      ZDATEX        DDCDAT
     C                   EVAL      DDCOM1 = %SUBST(CHCOMM:1:64)
     C                   EVAL      DDCOM2 = %SUBST(CHCOMM:65:64)
     C                   EVAL      DDCOM3 = %SUBST(CHCOMM:129:64)
     C                   EVAL      DDCOM4 = %SUBST(CHCOMM:193:64)

     C                   EVAL      *IN93 = '0'
     C                   WRITE     SDDCMTHS0

      ** Read Document Management comment history

     C                   EXSR      RDDMCH
     C                   ENDDO

     C                   IF        CHREFN <> DDREFN OR
     C                             CHCODE <> DDCODE
     C                   EVAL      WWEOF = 'Y'
     C                   EVAL      *IN96 = '1'
     C                   ENDIF

      ** Set up footer toggle text and write the footer

     C                   WRITE     SDDCMTHF0

      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record

     C                   IF        WWCNT = 0 AND
     C                             WWRRN = 0
     C                   EVAL      *IN97 = '1'
     C                   WRITE     SDDCMTHC0
     C                   EVAL      *IN97 = '0'
     C                   Z-ADD     1             WWRRN
     C                   Z-ADD     1             DDSFRN

      ** write to the subfile with non-display set on

     C                   EVAL      *IN93 = '1'
     C                   WRITE     SDDCMTHS0
     C                   EVAL      *IN93 = '0'
     C                   WRITE     SDDCMTHC0
     C                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDDCMTHC0
     C                   ENDIF

     C                   EVAL      WkCUSR = DFCUSR
     C                   EVAL      WkCDAT = DFCDAT
     C                   EVAL      WkCTIM = DFCTIM
     C                   EVAL      WkCOMM = DFCOMM

      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.

     C                   READ      SDDCMTHC0

      ** If F3, bypass further processing.
     C                   IF        *INKC = '1'
     C                   EVAL      PINKC = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

      ** If F5, Refresh screen details
     C                   IF        *INKE = '1'
     C                   EVAL      DFCUSR = *BLANK
     C                   EVAL      DFCDAT = *BLANK
     C                   EVAL      DFCTIM = *BLANK
     C                   EVAL      DFCOMM = *BLANK
     C                   ENDIF

      ** If F12, bypass further processing.
     C                   IF        *INKL = '1'
     C                   EVAL      PINKL = '1'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   IF        DFCUSR <> WkCUSR OR
     C                             DFCDAT <> WkCDAT OR
     C                             DFCTIM <> WkCTIM OR
     C                             DFCOMM <> WkCOMM
     C                   EVAL      WLOOP = 'N'
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RDDMCH - Read Document Management Comment History            *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     RDDMCH        BEGSR

      **  Reset End of File and skip record indicator

     C                   MOVE      *BLANK        WWEOF
     C                   Z-ADD     0             WWERR

      **  Read the file initially - if WWEOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.

     C                   DOU       WWEOF = 'Y' OR
     C                             WWERR = *ZERO

     C                   Z-ADD     0             WWERR
     C     KDMCH         READPE    SDDMCHL0                               96

      ** Select according to comment user name mask

     C                   IF        DFCUSR <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CHCUSR
     C                   PARM      10            LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFCUSR
     C                   PARM      10            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT

     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF

      ** Select according to comment date mask

     C                   IF        DFCDAT <> *BLANK
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DFCDAT        ZFIELD

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      6             ZADIG

     C     ZALIGNOK      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATE

     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM      *ZERO         SelDate
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   ELSE
     C                   Z-ADD     0             SelDATE
     C                   ENDIF

     C                   IF        SelDATE <> *ZERO
     C                   IF        CHCDAT >  SelDATE
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        DFCDAT <> *BLANK
     C                   IF        DFCTIM <> *BLANK
     C                   TESTN                   DFCTIM               9191
     C                   IF        *IN91 <> '1'
     C                   MOVE      '000000'      SelTIME
     C                   ELSE
     C                   MOVE      DFCTIM        SelTIME
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '999999'      SelTIME
     C                   ENDIF
     C                   IF        CHCTIM > SelTIME
     C                             AND CHCDAT >= SelDATE
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF

      ** Select according to comment detail mask

     C                   IF        DFCOMM <> *BLANK
     C                   CALL      'QCLSCAN'
     C                   PARM                    CHCOMM
     C                   PARM      256           LENGTH1
     C                   PARM      1             START
     C                   PARM                    DFCOMM
     C                   PARM      64            LENGTH2
     C                   PARM      '1'           TRANSLATE
     C                   PARM      '1'           TRIM
     C                   PARM      '?'           WILD
     C                   PARM                    RESULT

     C                   IF        RESULT < 1
     C                   Z-ADD     1             WWERR
     C                   ENDIF
     C                   ENDIF


     C                   WRITE     SDDCMTHF0

     C                   IF        *IN96 = '1'
     C                   MOVEL     'Y'           WWEOF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST - Get Customer or Naho Details                        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR

     C                   EVAL      DHCUST = DDREFN

      ** For Customer

     C                   IF        DDRTYP = 'C'
     C                   EVAL      *IN60 = '1'
     C                   MOVE      *BLANKS       PCNum
     C                   MOVE      DDREFN        PCNum
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNum
     C                   PARM      *BLANKS       PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     BBCSSN        DHCSSN
     C                   MOVEL     BBCRNM        DHCRNM
     C                   MOVEL     BBCRTN        DHCRTN
     C                   ELSE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

      ** For Non-Account Holder

     C                   IF        DDRTYP = 'N'
     C                   EVAL      *IN60 = '0'
     C                   MOVEL     DDREFN        PNAHO
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY

     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     *BLANKS       DHCSSN
     C                   MOVEL     NHNATW        DHCRTN
     C                   MOVEL     NHNARN        DHCRNM
     C                   ELSE
     C                   MOVEL     'SDNAHOPD'    DBFILE
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDATE2 - Format date for output                            *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDATE2      BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATEX
     C                   PARM                    ZADATE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

     C                   PARM                    RetCodeIn
     C                   PARM                    DDREFN
     C                   PARM                    DDRTYP
     C                   PARM                    DDCODE
     C                   PARM                    DDNARR
     C                   PARM                    DDSEQN
     C                   PARM                    PINKC
     C                   PARM                    PINKL

      ** Initialize program name
     C                   MOVEL     'SDDCMT2BW'   DBPGM

      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER

      ** Define Key List KDMCH
     C     KDMCH         KLIST
     C                   KFLD                    DDREFN
     C                   KFLD                    DDRTYP
     C                   KFLD                    DDCODE
     C                   KFLD                    WSEQN

      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      DDMRDT = BJMRDT
     C                   ENDIF

     C                   MOVE      *BLANK        DFCUSR
     C                   MOVE      *BLANK        DFCDAT
     C                   MOVE      *BLANK        DFCOMM
     C                   MOVE      '0'           PINKC
     C                   MOVE      '0'           PINKE
     C                   MOVE      '0'           PINKL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
