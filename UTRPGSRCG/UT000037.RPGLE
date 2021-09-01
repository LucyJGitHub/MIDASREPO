     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT ADBU compare report')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000037 - ADBU compare report                               *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE     Date 17Mar20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     FUTCMPFPD  IF   E           K DISK
      *
     D PFile           S             10
     D PKFile          S             10
     D PKFlds          S            120
     D PDspNoDiff      S              4
     D Cx              S              2  0
     D Ix              S              2  0
     D HI              S              1
     D Select          S              1
     D PMode           S              1
     D Type            S              2
     D PrvSearch       S             50
     D WSearch         S             50
     D W50             S             50
     D PrvMtch         S              1
     D WSeqn           S             10  0
     D WFil1           S             10
     D WFil2           S             10
     D WJob            S             26
     D X               S              3  0
     D Y               S              2  0

      * QCLSCAN variables.
     D SearchStr       S            256
     D SearchLen       S              3  0 INZ(256)
     D StrPos          S              3  0 INZ(1)
     D FindStr         S             50
     D FindLen         S              3  0 INZ(50)
     D Transl          S              1    INZ('1')
     D Trim            S              1    INZ('1')
     D WildCard        S              1    INZ('?')
     D FindPos         S              3  0

     D UBA             S              1    DIM(4400)
     D UPA             S              1    DIM(4400)

     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
     D                 DS
     D  XXJOB                  1     26
     D  JOJOB                  1     10
     D  JOUSER                11     20
     D  JONBR                 21     26  0
     D  JONBRA                21     26
      *
     D                 DS
     D  SSSEQA                 1     10
     D  JOS                    1     10
     D                                     DIM(10)
      *
     D                 DS
     D  SSSRCH                 1     50
     D  SEA                    1     50
     D                                     DIM(50)
      *
     D NWFILE          S             10A
     D SVFILE          S             10A
     D LIB1            S             10A
     D LIB2            S             10A
     D SetLib          S              1A

     D                 DS
     D  WKFld                  1    120
     D  SSKF01                 1     10
     D  SSKF02                11     20
     D  SSKF03                21     30
     D  SSKF04                31     40
     D  SSKF05                41     50
     D  SSKF06                51     60
     D  SSKF07                61     70
     D  SSKF08                71     80
     D  SSKF09                81     90
     D  SSKF10                91    100
     D  SSKF11               101    110
     D  SSKF12               111    120
      *
     C     *ENTRY        PLIST
     C                   PARM                    @LIB1            10
     C                   PARM                    @LIB2            10
     C                   PARM                    FILE             10
     C                   PARM                    DSP1             10
     C                   PARM                    DSP2             10

     C                   EVAL      Cx = 15
     C                   EVAL      LIB1 = @LIB1
     C                   EVAL      LIB2 = @LIB2
      * For Hi-intensity.
     C                   BITOFF    '01234567'    HI
     C                   BITON     '267'         HI
      *
      *
      * if UT000037 is called from UPC4012 (Reconcile), need to set LIB1 and LIB2
     C                   eval      SetLib ='N'
     C                   if        %SUBST(LIB1:3:8) = *BLANKS
     C                   eval      SetLib ='Y'
     C                   Endif
      *
     C                   READ      UTCMPFPD                               LR
     C   LR              RETURN

     C     *INLR         DOWEQ     '0'

      * if UT000037 is called from UPC4012 (Reconcile), need to set LIB1 and LIB2
     C                   if        SetLib = 'Y'
     C                   If        DSP1 = 'DSPFFD1'
     C                             or DSP2 = 'DSPFFD2'
     C                   eval      LIB1 = %SUBST(CFDATA:11:10)
     C                   eval      LIB2 = %SUBST(LIB2:1:2) + %SUBST(CFDATA:13:8)
     C                   Else
     C                   eval      LIB1 = %SUBST(CFDATA:24:10)
     C                   eval      LIB2 = %SUBST(LIB2:1:2) + %SUBST(CFDATA:26:8)
     C                   Endif
     C                   Endif

     C                   MOVEL     *BLANK        MODE
     C                   MOVEA     CFDATA        UBA
     C                   MOVEA     *BLANK        UPA
     C                   MOVEL     CFTYPE        ENTT
     C                   If        DSP1 = 'DSPFFD1'
     C                             or DSP2 = 'DSPFFD2'
     C                   eval      W#FILE = CFDATA
     C                   else
     C                   eval      W#FILE = %SUBST(CFDATA:14:10)
     C                   Endif

      * If 'EX' and CFFIL1 is set to DSPFFD1, check that file exists in LIB2
     C     CFTYPE        IFEQ      'EX'
     C     CFFIL1        ANDEQ     DSP1
     C                   If        DSP1 = 'DSPFFD1'
     C                   eval      W#FILE = CFDATA
     C                   else
     C                   eval      W#FILE = %SUBST(CFDATA:14:10)
     C                   Endif
      * Check whether object does actually exist in '*LIBL'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      W#FILE        P2OBNM           10
     C                   PARM      LIB2          P2TLIB           10
     C                   PARM      '*FILE'       P2OBTP            8
     C                   PARM                    CHKMBR           10
     C     RTNCOD        IFNE      'Exist'
     C                   eval      #NARR = 'NOT FOUND'
      * if 'file not found' when compare is for *MBRLIST or *RCDFMT, do not report
      * as this was already reported for *BASATR
     C                   If        DSP1 = 'DSPFDMB1'
     C                             or DSP1 = 'DSPFDRF1'
      * or if 'file not found' when compare is for *BASATR for PF, do not report
      * as this was already reported for DSPFFD
     C                             or (DSP1 = 'DSPFDBA1' and
     C                              %subst(LIB1:4:1) <> 'V')
     C                   Else
     C                   CALL      'UT000039'
     C                   PARM      LIB1          #LIB1            10
     C                   PARM      *BLANKS       #LIB2            10
     C                   PARM                    W#FILE
     C                   PARM                    #FATR             4
     C                   PARM                    #NARR            10
     C                   PARM                    #FIELD           10
     C                   PARM                    RPGN              6
     C                   PARM                    DESC             50
     C                   PARM                    DAT              40
     C                   PARM                    DSP40            40
     C                   PARM                    @WHDS           132
     C                   PARM      LIB1          #JOB             10
     C                   Endif

      * Now read until next file
     C                   eval      SVFILE = W#FILE
     C                   eval      NWFILE = W#FILE
     C                   DOU       SVFILE <> NWFILE
     C                             or *INLR = *ON
     C                   READ      UTCMPFPD                               LR
     C                   eval      NWFILE = CFDATA
     C                   ENDDO
     C                   goto      LOOP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C* If 'EX' and CFFIL2 is set to DSPFFD2, check that file exists in LIB1
     C     CFTYPE        IFEQ      'EX'
     C     CFFIL2        ANDEQ     DSP2
     C                   If        DSP2 = 'DSPFFD2'
     C                   eval      W#FILE = CFDATA
     C                   else
     C                   eval      W#FILE = %SUBST(CFDATA:14:10)
     C                   Endif
     C***********        eval      W#FILE = CFDATA
      * Check whether object does actually exist in '*LIBL'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RTNCOD           10
     C                   PARM      W#FILE        P2OBNM           10
     C                   PARM      LIB1          P2TLIB           10
     C                   PARM      '*FILE'       P2OBTP            8
     C                   PARM                    CHKMBR           10
     C     RTNCOD        IFNE      'Exist'
     C                   eval      #NARR = 'NOT FOUND'
      * if 'file not found' when compare is for *MBRLIST or *RCDFMT, do not report
      * as this was already reported for *BASATR
     C                   If        DSP1 = 'DSPFDMB1'
     C                             or DSP1 = 'DSPFDRF1'
      * or if 'file not found' when compare is for *BASATR for PF, do not report
      * as this was already reported for DSPFFD
     C                             or (DSP1 = 'DSPFDBA1' and
     C                              %subst(LIB2:4:1) <> 'V')
     C                   Else
     C                   CALL      'UT000039'
     C                   PARM      *BLANKS       #LIB1
     C                   PARM      LIB2          #LIB2
     C                   PARM                    W#FILE
     C                   PARM                    #FATR             4
     C                   PARM                    #NARR            10
     C                   PARM                    #FIELD           10
     C                   PARM                    RPGN              6
     C                   PARM                    DESC             50
     C                   PARM                    DAT              40
     C                   PARM                    DSP40            40
     C                   PARM                    @WHDS           132
     C                   PARM      LIB1          #JOB             10
     C                   Endif

      * Now read until next file
     C                   eval      SVFILE = W#FILE
     C                   eval      NWFILE = W#FILE
     C                   DOU       SVFILE <> NWFILE
     C                             or *INLR = *ON
     C                   READ      UTCMPFPD                               LR
     C                   eval      NWFILE = CFDATA
     C                   ENDDO
     C                   goto      LOOP
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     CFTYPE        IFEQ      'U1'
     C     CFTYPE        OREQ      'M1'
     C                   MOVEL     'U1'          ENTT
     C                   READ      UTCMPFPD                               LR
     C                   MOVEA     CFDATA        UPA
     C                   END
     C*
     C** If CFFIL1 not blank, the field exist in File1 only, set ENTT to 'EZ'
     C     CFFIL1        IFNE      *BLANKS
     C     ENTT          ANDEQ     'EX'
     C                   MOVEL     'EZ'          ENTT
     C                   ENDIF
      *
     C                   CALL      'UT000038'
     C                   PARM                    W#FILE           10
     C                   PARM                    MODE              1
     C                   PARM                    UBA
     C                   PARM                    UPA
     C                   PARM                    ENTT              2
     C                   PARM                    DSP1             10
     C                   PARM                    LIB1
     C                   PARM                    LIB2
     C                   READ      UTCMPFPD                               LR
     C     LOOP          TAG
     C                   ENDDO
      *
