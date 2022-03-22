     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('SD Currency/Time of Netting Details Conversion')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCTNMCVT - Currency/Time of Netting Details Conversion:     *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of the Currency/  *
      *             Time of Netting Details from file to screen       *
      *             format                                            *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD059520           Date 21Feb22               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1086546 *CREATE  Date 18Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059520 - Fusion Midas, Customer details Currency/Time of   *
      *             netting tab not showing records.                  *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1086546 - CDL025 upgrade to MP1.4. (Child: AR1086547).     *
      *              Applied for MD021813                             *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------

      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------

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

     D TranFilFmt    E DS                  EXTNAME(SDVCTNMPD)
     D                                     PREFIX(V_)
      ** Currency/Time of Netting Details in File Format

     D TrnDets       E DS                  EXTNAME(SDCCTNPD)
      ** Currency/Time of Netting Details in Screen Format

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WACTN           S              1A
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************


      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialisation

     C                   EXSR      SRINIT

      ** Set screen fields

     C                   EXSR      SRSCREEN

      ** Return

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Program Parameters

     C     *ENTRY        PLIST

      ** Input Parameters
      ** Return Code

     C                   PARM                    RetCodeIn

      ** Currency/Time of Netting Details File Format

     C                   PARM                    TranFilFmt

      ** Output Parameters
      ** Currency/Time of Netting Details Screen Format

     C                   PARM                    TrnDets

      ** Initialise program name

     C                   EVAL      DBPGM = 'SDCTNMCVT'

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE =  900
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR

      ** Blank outputs (EXCEPT FOR ACTION CODE)

     C                   MOVEL     DDACTN        WACTN
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     WACTN         DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCREEN - Set Screen Fields                                 *
      *                                                               *
      *****************************************************************
     C     SRSCREEN      BEGSR

      ** Customer Number

     C                   EVAL      DDCUST      =  V_TNCUST

      ** Currency/Time and Release Notice Days field set-up

     C                   EVAL      DDCCY1_1 = V_TNCCY1_1
     C                   EVAL      DDCCY2_1 = V_TNCCY2_1
     C                   EVAL      DDTIME_1 = V_TNTIME_1
     C                   EVAL      DDRNTD_1 = V_TNRNTD_1
     C                   EVAL      DDCCY1_2 = V_TNCCY1_2
     C                   EVAL      DDCCY2_2 = V_TNCCY2_2
     C                   EVAL      DDTIME_2 = V_TNTIME_2
     C                   EVAL      DDRNTD_2 = V_TNRNTD_2
     C                   EVAL      DDCCY1_3 = V_TNCCY1_3
     C                   EVAL      DDCCY2_3 = V_TNCCY2_3
     C                   EVAL      DDTIME_3 = V_TNTIME_3
     C                   EVAL      DDRNTD_3 = V_TNRNTD_3
     C                   EVAL      DDCCY1_4 = V_TNCCY1_4
     C                   EVAL      DDCCY2_4 = V_TNCCY2_4
     C                   EVAL      DDTIME_4 = V_TNTIME_4
     C                   EVAL      DDRNTD_4 = V_TNRNTD_4
     C                   EVAL      DDCCY1_5 = V_TNCCY1_5
     C                   EVAL      DDCCY2_5 = V_TNCCY2_5
     C                   EVAL      DDTIME_5 = V_TNTIME_5
     C                   EVAL      DDRNTD_5 = V_TNRNTD_5
     C                   EVAL      DDCCY1_6 = V_TNCCY1_6
     C                   EVAL      DDCCY2_6 = V_TNCCY2_6
     C                   EVAL      DDTIME_6 = V_TNTIME_6
     C                   EVAL      DDRNTD_6 = V_TNRNTD_6
     C                   EVAL      DDCCY1_7 = V_TNCCY1_7
     C                   EVAL      DDCCY2_7 = V_TNCCY2_7
     C                   EVAL      DDTIME_7 = V_TNTIME_7
     C                   EVAL      DDRNTD_7 = V_TNRNTD_7
     C                   EVAL      DDCCY1_8 = V_TNCCY1_8
     C                   EVAL      DDCCY2_8 = V_TNCCY2_8
     C                   EVAL      DDTIME_8 = V_TNTIME_8
     C                   EVAL      DDRNTD_8 = V_TNRNTD_8
     C                   EVAL      DDCCY1_9 = V_TNCCY1_9
     C                   EVAL      DDCCY2_9 = V_TNCCY2_9
     C                   EVAL      DDTIME_9 = V_TNTIME_9
     C                   EVAL      DDRNTD_9 = V_TNRNTD_9
     C                   EVAL      DDCCY1_10 = V_TNCCY1_10
     C                   EVAL      DDCCY2_10 = V_TNCCY2_10
     C                   EVAL      DDTIME_10 = V_TNTIME_10
     C                   EVAL      DDRNTD_10 = V_TNRNTD_10
     C                   EVAL      DDCCY1_11 = V_TNCCY1_11                                  MD059520
     C                   EVAL      DDCCY2_11 = V_TNCCY2_11                                  MD059520
     C                   EVAL      DDTIME_11 = V_TNTIME_11                                  MD059520
     C                   EVAL      DDRNTD_11 = V_TNRNTD_11                                  MD059520
     C                   EVAL      DDCCY1_12 = V_TNCCY1_12                                  MD059520
     C                   EVAL      DDCCY2_12 = V_TNCCY2_12                                  MD059520
     C                   EVAL      DDTIME_12 = V_TNTIME_12                                  MD059520
     C                   EVAL      DDRNTD_12 = V_TNRNTD_12                                  MD059520
     C                   EVAL      DDCCY1_13 = V_TNCCY1_13                                  MD059520
     C                   EVAL      DDCCY2_13 = V_TNCCY2_13                                  MD059520
     C                   EVAL      DDTIME_13 = V_TNTIME_13                                  MD059520
     C                   EVAL      DDRNTD_13 = V_TNRNTD_13                                  MD059520
     C                   EVAL      DDCCY1_14 = V_TNCCY1_14                                  MD059520
     C                   EVAL      DDCCY2_14 = V_TNCCY2_14                                  MD059520
     C                   EVAL      DDTIME_14 = V_TNTIME_14                                  MD059520
     C                   EVAL      DDRNTD_14 = V_TNRNTD_14                                  MD059520
     C                   EVAL      DDCCY1_15 = V_TNCCY1_15                                  MD059520
     C                   EVAL      DDCCY2_15 = V_TNCCY2_15                                  MD059520
     C                   EVAL      DDTIME_15 = V_TNTIME_15                                  MD059520
     C                   EVAL      DDRNTD_15 = V_TNRNTD_15                                  MD059520
     C                   EVAL      DDCCY1_16 = V_TNCCY1_16                                  MD059520
     C                   EVAL      DDCCY2_16 = V_TNCCY2_16                                  MD059520
     C                   EVAL      DDTIME_16 = V_TNTIME_16                                  MD059520
     C                   EVAL      DDRNTD_16 = V_TNRNTD_16                                  MD059520
     C                   EVAL      DDCCY1_17 = V_TNCCY1_17                                  MD059520
     C                   EVAL      DDCCY2_17 = V_TNCCY2_17                                  MD059520
     C                   EVAL      DDTIME_17 = V_TNTIME_17                                  MD059520
     C                   EVAL      DDRNTD_17 = V_TNRNTD_17                                  MD059520
     C                   EVAL      DDCCY1_18 = V_TNCCY1_18                                  MD059520
     C                   EVAL      DDCCY2_18 = V_TNCCY2_18                                  MD059520
     C                   EVAL      DDTIME_18 = V_TNTIME_18                                  MD059520
     C                   EVAL      DDRNTD_18 = V_TNRNTD_18                                  MD059520
     C                   EVAL      DDCCY1_19 = V_TNCCY1_19                                  MD059520
     C                   EVAL      DDCCY2_19 = V_TNCCY2_19                                  MD059520
     C                   EVAL      DDTIME_19 = V_TNTIME_19                                  MD059520
     C                   EVAL      DDRNTD_19 = V_TNRNTD_19                                  MD059520
     C                   EVAL      DDCCY1_20 = V_TNCCY1_20                                  MD059520
     C                   EVAL      DDCCY2_20 = V_TNCCY2_20                                  MD059520
     C                   EVAL      DDTIME_20 = V_TNTIME_20                                  MD059520
     C                   EVAL      DDRNTD_20 = V_TNRNTD_20                                  MD059520
     C                   EVAL      DDCCY1_21 = V_TNCCY1_21                                  MD059520
     C                   EVAL      DDCCY2_21 = V_TNCCY2_21                                  MD059520
     C                   EVAL      DDTIME_21 = V_TNTIME_21                                  MD059520
     C                   EVAL      DDRNTD_21 = V_TNRNTD_21                                  MD059520
     C                   EVAL      DDCCY1_22 = V_TNCCY1_22                                  MD059520
     C                   EVAL      DDCCY2_22 = V_TNCCY2_22                                  MD059520
     C                   EVAL      DDTIME_22 = V_TNTIME_22                                  MD059520
     C                   EVAL      DDRNTD_22 = V_TNRNTD_22                                  MD059520
     C                   EVAL      DDCCY1_23 = V_TNCCY1_23                                  MD059520
     C                   EVAL      DDCCY2_23 = V_TNCCY2_23                                  MD059520
     C                   EVAL      DDTIME_23 = V_TNTIME_23                                  MD059520
     C                   EVAL      DDRNTD_23 = V_TNRNTD_23                                  MD059520
     C                   EVAL      DDCCY1_24 = V_TNCCY1_24                                  MD059520
     C                   EVAL      DDCCY2_24 = V_TNCCY2_24                                  MD059520
     C                   EVAL      DDTIME_24 = V_TNTIME_24                                  MD059520
     C                   EVAL      DDRNTD_24 = V_TNRNTD_24                                  MD059520
     C                   EVAL      DDCCY1_25 = V_TNCCY1_25                                  MD059520
     C                   EVAL      DDCCY2_25 = V_TNCCY2_25                                  MD059520
     C                   EVAL      DDTIME_25 = V_TNTIME_25                                  MD059520
     C                   EVAL      DDRNTD_25 = V_TNRNTD_25                                  MD059520
     C                   EVAL      DDCCY1_26 = V_TNCCY1_26                                  MD059520
     C                   EVAL      DDCCY2_26 = V_TNCCY2_26                                  MD059520
     C                   EVAL      DDTIME_26 = V_TNTIME_26                                  MD059520
     C                   EVAL      DDRNTD_26 = V_TNRNTD_26                                  MD059520
     C                   EVAL      DDCCY1_27 = V_TNCCY1_27                                  MD059520
     C                   EVAL      DDCCY2_27 = V_TNCCY2_27                                  MD059520
     C                   EVAL      DDTIME_27 = V_TNTIME_27                                  MD059520
     C                   EVAL      DDRNTD_27 = V_TNRNTD_27                                  MD059520
     C                   EVAL      DDCCY1_28 = V_TNCCY1_28                                  MD059520
     C                   EVAL      DDCCY2_28 = V_TNCCY2_28                                  MD059520
     C                   EVAL      DDTIME_28 = V_TNTIME_28                                  MD059520
     C                   EVAL      DDRNTD_28 = V_TNRNTD_28                                  MD059520
     C                   EVAL      DDCCY1_29 = V_TNCCY1_29                                  MD059520
     C                   EVAL      DDCCY2_29 = V_TNCCY2_29                                  MD059520
     C                   EVAL      DDTIME_29 = V_TNTIME_29                                  MD059520
     C                   EVAL      DDRNTD_29 = V_TNRNTD_29                                  MD059520
     C                   EVAL      DDCCY1_30 = V_TNCCY1_30                                  MD059520
     C                   EVAL      DDCCY2_30 = V_TNCCY2_30                                  MD059520
     C                   EVAL      DDTIME_30 = V_TNTIME_30                                  MD059520
     C                   EVAL      DDRNTD_30 = V_TNRNTD_30                                  MD059520
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Format a date for output                            *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR

     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZEDIT - Edit an unsigned field                               *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR

     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE

      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2013
