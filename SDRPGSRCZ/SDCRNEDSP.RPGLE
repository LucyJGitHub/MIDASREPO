     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CRS Non-Account Holder Exception Detail')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDCRNEDSP - CRS Non-Account Holder Exception Detail          *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL177             Date 11Jan16               *
      *  Prev Amend No. MD036243           Date 20Oct15               *
      *                 CGL157   *CREATE   Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036243 - No non-account holder details in CRS Exception    *
      *             List (Recompile)                                  *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** SD Exception Management Detail
     FSDEXMAL0  IF   E           K DISK    INFSR(*PSSR)

      ** SD Exception Management Subfile
     FSDCRNEDF  CF   E             WORKSTN SFILE(SDCRNES1:WWRRN)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D WWCTIM          DS
     D  WWHH                   1      2
     D  WWMM                   4      5
     D  WWSS                   7      8

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for customer details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** New Non-A/C Holder in Screen Format - CRS Details                                    CGL157
     D NewCuCRNH     E DS                  EXTNAME(SDCRNSPD)
     D                                     PREFIX(C_)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Access Object Parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PKeySts         S              7A
     D PNAHO           S             10A
     D DDSCDT          S              5P 0
     D DDSEQN          S              3S 0
     D WWCUSR          S             10A
     D WWCDAT          S              6A
     D WWRRN           S              5P 0
     D WWCNT           S              3P 0
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
     D SelDate         S              5P 0
     D Errorflag       S              1A
     D ZALIGNOK        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D DDCDAT          S              5P 0
     D WWHHMM          S              4A
     D WWTIME          S              6A
     D DDNAHO          S             10A
     D DDEXMA          S              1A
     D DDEXID          S             30A
     D DDDESC          S             60A
     D DDCDFF          S              5A
     D DDCTIF          S              8A
     D DDCTIM          S              6S 0
     D X               S              2S 0
     D Y               S              2S 0
     D KEXMA           S              1A
     D WEXMA2          S              1A
     D WEINKX          S              1A
     D WINKC           S              1A
     D WINKL           S              1A
     D WINKR           S              1A
     D WINKS           S              1A
     D WINKX           S              1A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C                   EVAL      DDNAHO = C_DDNAHR
     C                   EVAL      DDEXMG = C_DDEXMG                                          CGL177
     C                   EVAL      DDEXID = C_DDEXMI

      ** Build Sub-file

     C                   EXSR      BLDSFL

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE
      *****************************************************************

     C     BLDSFL        BEGSR

     C     WEINKX        COMP      'Y'                                    73
     C                   SETOFF                                       96

      ** Initialise subfile relative record number.

     C                   Z-ADD     0             WWRRN

      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.

     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNES0
     C                   MOVE      '0'           *IN97

     C                   MOVE      *BLANKS       PNAHO
     C                   MOVE      DDNAHO        PNAHO

     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY

     C                   MOVEL     NHNAHO        DDNAHO
     C                   MOVEL     NHNARN        DDNARN
     C                   MOVEL     NHNATW        DDNATW
     C                   EVAL      WWCNT = 0
     C                   EVAL      X = 1
     C                   EVAL      Y = 1
     C                   SETON                                        8098

     C                   DOW       *IN98 = '1' AND
     C                             X < 31

     C                   EVAL      KEXMA = %SUBST(C_DDEXMI:X:1)
     C                   Z-ADD     WWRRN         DDSFRN
     C                   MOVE      '0'           *IN93

     C                   IF        KEXMA <> ' '
     C                   MOVE      *OFF          *IN80

     C     KEXMA         CHAIN     SDEXMAL0

     C                   IF        %FOUND(SDEXMAL0) AND
     C                             Y = 3
     C                   EVAL      DDEXC1 = %SUBST(FEEXDE:1:64)
     C                   EVAL      DDEXC2 = %SUBST(FEEXDE:65:64)
     C                   EVAL      DDEXC3 = %SUBST(FEEXDE:129:64)
     C                   EVAL      DDEXC4 = %SUBST(FEEXDE:193:64)
     C                   EVAL      Y = 4
     C                   ADD       1             WWCNT
     C                   EVAL      WEXMA2 = %SUBST(DDEXID:X+1:1)
     C                   IF        WEXMA2 = ' '
     C                   SETON                                        96
     C                   ENDIF
     C                   ENDIF

     C                   IF        %FOUND(SDEXMAL0) AND
     C                             Y = 2
     C                   EVAL      DDEXB1 = %SUBST(FEEXDE:1:64)
     C                   EVAL      DDEXB2 = %SUBST(FEEXDE:65:64)
     C                   EVAL      DDEXB3 = %SUBST(FEEXDE:129:64)
     C                   EVAL      DDEXB4 = %SUBST(FEEXDE:193:64)
     C                   EVAL      Y = 3
     C                   ADD       1             WWCNT
     C                   ENDIF

     C                   IF        %FOUND(SDEXMAL0) AND
     C                             Y = 1
     C                   EVAL      DDEXA1 = %SUBST(FEEXDE:1:64)
     C                   EVAL      DDEXA2 = %SUBST(FEEXDE:65:64)
     C                   EVAL      DDEXA3 = %SUBST(FEEXDE:129:64)
     C                   EVAL      DDEXA4 = %SUBST(FEEXDE:193:64)
     C                   EVAL      Y = 2
     C                   ADD       1             WWCNT

      ** Increment the subfile record no. and records written fields.

     C                   ADD       1             WWRRN

     C                   ENDIF

     C                   ENDIF

     C                   IF        Y = 4 OR
     C                             KEXMA = ' '

     C                   IF        KEXMA = ' '
     C                   SETON                                        96
     C                   ENDIF

     C                   IF        Y > 1
     C                   WRITE     SDCRNES1
     C                   ENDIF

      ** Set up footer toggle text and write the footer

     C                   WRITE     SDCRNEF1

      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record

     C                   IF        WWCNT = 0 AND
     C                             WWRRN = 0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDCRNES0
     C                   MOVE      '0'           *IN97
     C                   Z-ADD     1             WWRRN
     C                   Z-ADD     1             DDSFRN

      ** write to the subfile with non-display set on

     C                   MOVE      '1'           *IN93
     C                   WRITE     SDCRNES1
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDCRNES0
     C                   ELSE

      **  Write the subfile control record to the screen to display
      **  the subfile.

     C                   WRITE     SDCRNES0
     C                   ENDIF

     C                   EVAL      Y = 1

      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.

     C                   READ      SDCRNES0

     C                   EVAL      DDEXA1 = *BLANKS
     C                   EVAL      DDEXA2 = *BLANKS
     C                   EVAL      DDEXA3 = *BLANKS
     C                   EVAL      DDEXA4 = *BLANKS
     C                   EVAL      DDEXB1 = *BLANKS
     C                   EVAL      DDEXB2 = *BLANKS
     C                   EVAL      DDEXB3 = *BLANKS
     C                   EVAL      DDEXB4 = *BLANKS
     C                   EVAL      DDEXC1 = *BLANKS
     C                   EVAL      DDEXC2 = *BLANKS
     C                   EVAL      DDEXC3 = *BLANKS
     C                   EVAL      DDEXC4 = *BLANKS
     C                   ENDIF

      ** If F3, bypass further processing.
     C                   IF        *INKC = '1'
     C                   MOVEL     '1'           WINKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF

     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************

     C     *INZSR        BEGSR

      ** Parameters

     C     *ENTRY        PLIST

     C                   PARM                    RetCodeIn
      **  New Non-A/C Holder in Screen Format - CRS Details
     C                   PARM                    NewCuCRNH
     C                   PARM                    WINKC
     C                   PARM                    WINKL

      ** Initialize program name
     C                   MOVEL     'SDCRNEDSP'   DBPGM

      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER

      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C                   IF        PRtCd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      '0'           WINKC
     C                   MOVE      '0'           WINKL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
