     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
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
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. AR1086546 *CREATE  Date 18Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
(c) Misys International Banking Systems Ltd. 2013
