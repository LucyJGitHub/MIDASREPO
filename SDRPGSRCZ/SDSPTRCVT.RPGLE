     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate: To Scrn Frmt')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRCVT - Spot Rate Transaction Details Conversion:        *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Spot Rate    *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 11Aug05               *
      *                 BUG4064            Date 30Aug04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057  *CREATE    Date 20Oct00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130 - Recompiled due to changes in SDVSPTRPD             *
      *  BUG4064 - Spot Trade Account Code blanked out due to wrong   *
      *            data structure used for the passed parameter.      *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
     D*TranFilFmt    E DS                  EXTNAME(SDCURRPD)                                 BUG4064
     D SPTRFilFmt    E DS                  EXTNAME(SDVSPTRPD)                                BUG4064
      ** Spot Rate Transaction Details in File Format
 
     D TrnDets       E DS                  EXTNAME(SDSPTRPD)
     D   DDTSDT                       6    OVERLAY(DDDFTS:3)
     D   DDTSTM                       6    OVERLAY(DDDFTS:9)
      ** Spot Rate Transaction Details in Screen Format
 
 
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
     D DateIn          S              8S 0
      *                                                                                       CER048
      ** Variable for feature CER048                                                          CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
      *                                                                                       CER048
      ** Parameters for access object programs                                                CER048
      *                                                                                       CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      INIT
 
      ** Set screen fields
 
     C                   EXSR      SCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Currency code
     C**********         Eval      DDCYCD = A6CYCD                                           BUG4064
     C                   Eval      DDCYCD = AVCYCD                                           BUG4064
 
      * Currency Name
     C**********         Eval      DDCYNM = A6CYNM                                           BUG4064
     C                   Eval      DDCYNM = AVCYNM                                           BUG4064
 
     C     CEU002        IFEQ      'Y'
      ** Formating specific to euro rate
     C                   EXSR      FMEURT
     C                   ELSE
      * Spot Rate
     C*****A6SPRT        IFEQ      *ZERO                                                     BUG4064
     C     AVSPRT        IFEQ      *ZERO                                                     BUG4064
     C                   MOVEL     *BLANKS       DDSPRT
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   Z-ADD     8             ZADEC                    130869
     C**********         MOVE      A6SPRT        ZFIELD                                      BUG4064
     C                   MOVE      AVSPRT        ZFIELD                                      BUG4064
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDSPRT
     C                   ENDIF
 
      * Multiply / Divide indicator
     C**********         Eval      DDMDIN = A6MDIN                                           BUG4064
     C                   Eval      DDMDIN = AVMDIN                                           BUG4064
 
      * Dealing currency
     C**********         Eval      DDDLCY = A6DLCI                                           BUG4064
     C                   Eval      DDDLCY = AVDLCI                                           BUG4064
 
      * SWIFT currency code
     C**********         Eval      DDSWCY = A6SWCY                                           BUG4064
     C                   Eval      DDSWCY = AVSWCY                                           BUG4064
     C                   ENDIF
 
      * Data request id
     C**********         Eval      DDDTFR = A6DTFR                                           BUG4064
     C                   Eval      DDDTFR = AVDTFR                                           BUG4064
 
      * Time stamp
     C*****A6DFTS        IFEQ      *ZERO                                                     BUG4064
     C     AVDFTS        IFEQ      *ZERO                                                     BUG4064
     C                   EVAL      DDDFTS = *BLANK
     C                   ELSE
      ** Move last 6 digits HHMMSS
     C**********         MOVE      A6DFTS        DDTSTM                                      BUG4064
     C                   MOVE      AVDFTS        DDTSTM                                      BUG4064
      ** Move first 8 digits CCYYMMDD
     C**********         MOVEL     A6DFTS        DateIn                                      BUG4064
     C                   MOVEL     AVDFTS        DateIn                                      BUG4064
     C                   EXSR      ZA0770
     C                   MOVE      DateOut       DDTSDT
     C                   ENDIF
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   IF        AVTCMP = *ZEROS                                            CER048
     C                   EVAL      DDTCMP = *BLANKS                                           CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      ZFIELD = *BLANKS                                           CER048
     C                   Z-ADD     7             ZADEC                                        CER048
     C                   MOVE      AVTCMP        ZFIELD                                       CER048
     C                   EXSR      ZEDIT                                                      CER048
     C                   MOVE      ZFIELD        DDTCMP                                       CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMEURT - FORMATING SPECIFIC TO EURO RATE
      *****************************************************************
     C     FMEURT        BEGSR
     C******LIKE         DEFINE    A6CYCD        PICYCD                                      BUG4064
     C******LIKE         DEFINE    A6MDIN        PIMDIN                                      BUG4064
     C******LIKE         DEFINE    A6SPRT        PISPRT                                      BUG4064
     C******LIKE         DEFINE    A6INER        PIINER                                      BUG4064
     C******LIKE         DEFINE    A6INMD        PIINMD                                      BUG4064
     C******LIKE         DEFINE    A6DLCI        PIDLCI                                      BUG4064
     C******LIKE         DEFINE    A6SWCY        PISWCY                                      BUG4064
     C******LIKE         DEFINE    A6MDIN        #SMDIN                                      BUG4064
     C******LIKE         DEFINE    A6MDIN        #SMDI2                                      BUG4064
     C     *LIKE         DEFINE    AVCYCD        PICYCD                                      BUG4064
     C     *LIKE         DEFINE    AVMDIN        PIMDIN                                      BUG4064
     C     *LIKE         DEFINE    AVSPRT        PISPRT                                      BUG4064
     C     *LIKE         DEFINE    AVINER        PIINER                                      BUG4064
     C     *LIKE         DEFINE    AVINMD        PIINMD                                      BUG4064
     C     *LIKE         DEFINE    AVDLCI        PIDLCI                                      BUG4064
     C     *LIKE         DEFINE    AVSWCY        PISWCY                                      BUG4064
     C     *LIKE         DEFINE    AVMDIN        #SMDIN                                      BUG4064
     C     *LIKE         DEFINE    AVMDIN        #SMDI2                                      BUG4064
     C     *LIKE         DEFINE    #SPRA         #SPRA2
     C     *LIKE         DEFINE    DLSW          DLSW2
     C     *LIKE         DEFINE    DLSW          DDDLSW
     C     *LIKE         DEFINE    DLSW          DDDSW2
 
     C                   CALLB     'SDSPTRDEU'                          90
     C                   PARM                    RetCodeIn
     C**********         PARM      A6CYCD        PICYCD                                      BUG4064
     C**********         PARM      A6MDIN        PIMDIN                                      BUG4064
     C**********         PARM      A6SPRT        PISPRT                                      BUG4064
     C**********         PARM      A6INER        PIINER                                      BUG4064
     C**********         PARM      A6INMD        PIINMD                                      BUG4064
     C**********         PARM      A6DLCI        PIDLCI                                      BUG4064
     C**********         PARM      A6SWCY        PISWCY                                      BUG4064
     C                   PARM      AVCYCD        PICYCD                                      BUG4064
     C                   PARM      AVMDIN        PIMDIN                                      BUG4064
     C                   PARM      AVSPRT        PISPRT                                      BUG4064
     C                   PARM      AVINER        PIINER                                      BUG4064
     C                   PARM      AVINMD        PIINMD                                      BUG4064
     C                   PARM      AVDLCI        PIDLCI                                      BUG4064
     C                   PARM      AVSWCY        PISWCY                                      BUG4064
     C     DDSPRT        PARM                    #SPRA            14
     C     DDDLSW        PARM                    DLSW              6
     C     DDMDIN        PARM                    #SMDIN
     C     DDSPR2        PARM                    #SPRA2
     C     DDDSW2        PARM                    DLSW2
     C     DDMDI2        PARM                    #SMDI2
 
     C                   IF        RetCodeIn <> *BLANK OR *IN90
     C                   MOVEL     'SDSPTRDEU'   DBFILE
     C                   MOVEL     '001'         DBASE
     C**********         MOVEL     A6CYCD        DBKEY                                      BUG4064
     C                   MOVEL     AVCYCD        DBKEY                                      BUG4064
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If second line is not blank, It means DDSPRT is expressed
      ** against DDVSEU
     C     DDDSW2        IFEQ      *BLANK
     C                   EVAL      DDDLCY = %SUBST(DDDLSW:1)
     C                   EVAL      DDSWCY = %SUBST(DDDLSW:4)
     C                   ELSE
     C                   EVAL      DDVSEU = %SUBST(DDDLSW:4)
     C                   EVAL      DDDCY2 = %SUBST(DDDSW2:1)
     C                   EVAL      DDSWC2 = %SUBST(DDDSW2:4)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Format a date for output                             *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZA0770 - Convert YYYYMMDD to date XXXXXX                      *
      *                                                               *
      *****************************************************************
     C     ZA0770        BEGSR
 
     C                   CALLB     'ZA0770'
     C                   PARM                    RetCodeIn
     C                   PARM                    DateIn
     C                   PARM                    BJDFIN
     C                   PARM                    DateOut           6 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
 
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     ##ACTN        DDACTN
 
     C                   MOVEL     *BLANK        DDCYNM
     C                   MOVEL     *BLANK        DDDLCY
     C                   MOVEL     *BLANK        DDSWCY
     C                   MOVEL     *BLANK        DDVSEU
     C                   MOVEL     *BLANK        DDSPR2
     C                   MOVEL     *BLANK        DDMDI2
     C                   MOVEL     *BLANK        DDDCY2
     C                   MOVEL     *BLANK        DDSWC2
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Spot Rate Transaction Details File Format
     C**********         PARM                    TranFilFmt                                  BUG4064
     C                   PARM                    SPTRFilFmt                                  BUG4064
      *
 
      * Output Parameters
 
      * Spot Rate Transaction Details Screen Format
     C                   PARM                    TrnDets
 
      * Currency Name
     C                   PARM                    DDCYNM
 
      * Dealing currency
     C                   PARM                    DDDLCY
 
      * SWIFT currency code
     C                   PARM                    DDSWCY
 
      * BKEURO currency
     C                   PARM                    DDVSEU
 
      * Spot Rate against base currency (when DDSPRT is against BKEURO)
      * (output screen field)
     C                   PARM                    DDSPR2
 
      * Multiply divide indicator tied to DDSPR2
      * (output screen field)
     C                   PARM                    DDMDI2
 
      * Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2
 
      * Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2
 
 
     C******LIKE         DEFINE    A6DLCI        DDDCY2                                      BUG4064
     C******LIKE         DEFINE    A6SWCY        DDSWC2                                      BUG4064
     C******LIKE         DEFINE    A6CYCD        DDVSEU                                      BUG4064
     C******LIKE         DEFINE    A6MDIN        DDMDI2                                      BUG4064
     C     *LIKE         DEFINE    AVDLCI        DDDCY2                                      BUG4064
     C     *LIKE         DEFINE    AVSWCY        DDSWC2                                      BUG4064
     C     *LIKE         DEFINE    AVCYCD        DDVSEU                                      BUG4064
     C     *LIKE         DEFINE    AVMDIN        DDMDI2                                      BUG4064
     C     *LIKE         DEFINE    DDSPRT        DDSPR2
     C******LIKE         DEFINE    A6CYNM        DDCYNM                                      BUG4064
     C******LIKE         DEFINE    A6DLCI        DDDLCY                                      BUG4064
     C******LIKE         DEFINE    A6SWCY        DDSWCY                                      BUG4064
     C     *LIKE         DEFINE    AVCYNM        DDCYNM                                      BUG4064
     C     *LIKE         DEFINE    AVDLCI        DDDLCY                                      BUG4064
     C     *LIKE         DEFINE    AVSWCY        DDSWCY                                      BUG4064
 
      ** Initialize program name
 
     C                   MOVEL     'SDSPTRCVT'   DBPGM
 
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   END
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
