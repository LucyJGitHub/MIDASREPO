     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Non-A/c Holder Exception')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Details Module                              *
      *                                                               *
      *  SDFTNHEDP - FATCA Non-account HOlder Exception               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** SD Exception Management Detail
     FSDEXMAL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** SD Exception Management Subfile
     FSDFTNHEDF CF   E             WORKSTN SFILE(SDFTNES1:@@RRN)
 
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
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** New Customer in Screen Format - FATCA customer details
     D NewCuFATC     E DS                  EXTNAME(SDFTNRPD)
 
      ** Customer details
     D CrCuScnFmt    E DS                  EXTNAME(SDNAHLPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PKeySts         S              7A
     D PCNum           S             10A
     D DDSCDT          S              5P 0
     D DDSEQN          S              3S 0
     D WWCUSR          S             10A
     D WWCDAT          S              6A
     D @@RRN           S              5P 0
     D @@CNT           S              3P 0
     D @@ERR           S              1P 0
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
     D DDDESC          S             60A
     D DDCDFF          S              5A
     D DDCTIF          S              8A
     D DDCTIM          S              6S 0
     D X               S              2S 0
     D Y               S              2S 0
     D KEXMA           S              1A
     D WEXMA2          S              1A
     D @EINKX          S              1A
     D @INKC           S              1A
     D @INKQ           S              1A
     D @INKR           S              1A
     D @INKS           S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C                   EVAL      DDEXMA = DDEXMA
     C                   EVAL      DDEXID = DDEXID
 
      ** Build Sub-file
 
     C                   EXSR      BLDSFL
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDSFL - BUILD SUBFILE
      *****************************************************************
 
     C     BLDSFL        BEGSR
 
     C     @EINKX        COMP      'Y'                                    73
     C                   SETOFF                                       96
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             @@RRN
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDFTNES0
     C                   MOVE      '0'           *IN97
 
     C                   EVAL      @@CNT = 0
     C                   EVAL      X = 1
     C                   EVAL      Y = 1
     C                   SETON                                        8098
 
     C                   DOW       *IN98 = '1' AND
     C                             X < 31
 
     C                   EVAL      KEXMA = %SUBST(DDEXID:X:1)
     C                   Z-ADD     @@RRN         DDSFRN
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
     C                   ADD       1             @@CNT
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
     C                   ADD       1             @@CNT
     C                   ENDIF
 
     C                   IF        %FOUND(SDEXMAL0) AND
     C                             Y = 1
     C                   EVAL      DDEXA1 = %SUBST(FEEXDE:1:64)
     C                   EVAL      DDEXA2 = %SUBST(FEEXDE:65:64)
     C                   EVAL      DDEXA3 = %SUBST(FEEXDE:129:64)
     C                   EVAL      DDEXA4 = %SUBST(FEEXDE:193:64)
     C                   EVAL      Y = 2
     C                   ADD       1             @@CNT
 
      ** Increment the subfile record no. and records written fields.
 
     C                   ADD       1             @@RRN
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        Y = 4 OR
     C                             KEXMA = ' '
 
     C                   IF        KEXMA = ' '
     C                   SETON                                        96
     C                   ENDIF
 
     C                   IF        Y > 1
     C                   WRITE     SDFTNES1
     C                   ENDIF
 
      ** Set up footer toggle text and write the footer
 
     C                   WRITE     SDFTNEF1
 
      ** If there is no data to display, set on SFLCLR condition and
      ** write the subfile control record
 
     C                   IF        @@CNT = 0 AND
     C                             @@RRN = 0
     C                   MOVE      '1'           *IN97
     C                   WRITE     SDFTNES0
     C                   MOVE      '0'           *IN97
     C                   Z-ADD     1             @@RRN
     C                   Z-ADD     1             DDSFRN
 
      ** write to the subfile with non-display set on
 
     C                   MOVE      '1'           *IN93
     C                   WRITE     SDFTNES1
     C                   MOVE      '0'           *IN93
     C                   WRITE     SDFTNES0
     C                   ELSE
 
      **  Write the subfile control record to the screen to display
      **  the subfile.
 
     C                   WRITE     SDFTNES0
     C                   ENDIF
 
     C                   EVAL      Y = 1
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      SDFTNES0
 
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
     C                   MOVEL     '1'           @INKC
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If F16, bypass further processing.
     C                   IF        *INKQ = '1'
     C                   MOVEL     '1'           @INKQ
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If F17, bypass further processing.
     C                   IF        *INKR = '1'
     C                   MOVEL     '1'           @INKR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If F18, bypass further processing.
     C                   IF        *INKS = '1'
     C                   MOVEL     '1'           @INKS
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
     C                   PARM                    NewCuFATC
     C                   PARM                    CrCuScnFmt
     C                   PARM                    @INKC
     C                   PARM                    @INKQ
     C                   PARM                    @INKR
     C                   PARM                    @INKS
 
      ** Initialize program name
     C                   MOVEL     'SDFTNHEDP'   DBPGM
 
      ** Move workstation ID to screen field.
     C                   MOVEL     PsJobName     DDWID
     C                   MOVEL     PsUser        DDUSER
 
      ** Access bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      '0'           @INKC
     C                   MOVE      '0'           @INKQ
     C                   MOVE      '0'           @INKR
     C                   MOVE      '0'           @INKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
