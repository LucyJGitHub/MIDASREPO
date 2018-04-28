     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax Conversion:File to Sc Cv')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTCVT - Customer Withholding Tax  Details Conversion:    *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of the Customer   *
      *             Withholding Tax Details from file to screen format*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
 
     D TranFilFmt    E DS                  EXTNAME(SDVCUWTPD)
      ** Withholding Tax  Details in Valid File Format
 
     D TrnDets       E DS                  EXTNAME(SDCUWTPD)
      ** Withholding Tax  Details in Screen Format
 
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
 
     D PRTCD           S              7
     D POPTN           S              7
     D ##ACTN          S              1
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7
     D ZFIELD          S             16
     D ZADEC           S              1P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
 
     C                   EXSR      INIT
 
      ** Set screen fields
 
     C                   EXSR      SCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Withholding Tax Details File Format
 
     C                   PARM                    TranFilFmt
 
      ** Output Parameters
      ** Withholding Tax Details Screen Format
 
     C                   PARM                    TrnDets
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCUWTCVT'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANK
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
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
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
 
     C                   MOVEL     DDACTN        ##ACTN
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     ##ACTN        DDACTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SCREEN - SET SCREEN FIELDS                                   *
      *                                                               *
      *****************************************************************
     C     SCREEN        BEGSR
 
      ** Customer Number
 
     C                   EVAL      DDCSNO = WTCSNO
 
      ** Country of Tax Treaty1
 
     C                   EVAL      DDCRTT1 = WTCRTT1
 
      ** Intermediary Status1
 
     C                   EVAL      DDINTS1 = WTINTS1
 
      ** Documentation Received1
 
     C                   EVAL      DDDCRC1 = WTDCRC1
 
      ** Documentation Expiry Date1
 
     C                   IF        WTDCEX1 = *ZERO
     C                   EVAL      DDDCEX1 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX1
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX1 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX1
     C                   ENDIF
 
      ** Exemption Code1
 
     C                   EVAL      DDEXCD1 = WTEXCD1
 
      ** Backup WHT Applicable Y/N 1
 
     C                   EVAL      DDBCWA1 = WTBCWA1
 
      ** Recipient Code1
 
     C                   EVAL      DDRPCD1 = WTRPCD1
 
      ** Tax Basket1
 
     C                   EVAL      DDTXBS1 = WTTXBS1
 
      ** Report Foreign Source Income Y/N 1
 
     C                   EVAL      DDRFSI1 = WTRFSI1
 
      ** Double Tax Treaty Y/N 1
 
     C                   EVAL      DDDBTT1 = WTDBTT1
 
      ** Tax Identification Number1
 
     C                   EVAL      DDTIN1  = WTTIN1
 
      ** Country of Tax Treaty2
 
     C                   EVAL      DDCRTT2 = WTCRTT2
 
      ** Intermediary Status2
 
     C                   EVAL      DDINTS2 = WTINTS2
 
      ** Documentation Received2
 
     C                   EVAL      DDDCRC2 = WTDCRC2
 
      ** Documentation Expiry Date2
 
     C                   IF        WTDCEX2 = *ZERO
     C                   EVAL      DDDCEX2 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX2
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX2 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX2
     C                   ENDIF
 
      ** Exemption Code2
 
     C                   EVAL      DDEXCD2 = WTEXCD2
 
      ** Backup WHT Applicable Y/N 2
 
     C                   EVAL      DDBCWA2 = WTBCWA2
 
      ** Recipient Code2
 
     C                   EVAL      DDRPCD2 = WTRPCD2
 
      ** Tax Basket2
 
     C                   EVAL      DDTXBS2 = WTTXBS2
 
      ** Report Foreign Source Income Y/N 2
 
     C                   EVAL      DDRFSI2 = WTRFSI2
 
      ** Double Tax Treaty Y/N 2
 
     C                   EVAL      DDDBTT2 = WTDBTT2
 
      ** Tax Identification Number2
 
     C                   EVAL      DDTIN2  = WTTIN2
 
      ** Country of Tax Treaty3
 
     C                   EVAL      DDCRTT3 = WTCRTT3
 
      ** Intermediary Status3
 
     C                   EVAL      DDINTS3 = WTINTS3
 
      ** Documentation Received3
 
     C                   EVAL      DDDCRC3 = WTDCRC3
 
      ** Documentation Expiry Date3
 
     C                   IF        WTDCEX3 = *ZERO
     C                   EVAL      DDDCEX3 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX3
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX3 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX3
     C                   ENDIF
 
      ** Exemption Code3
 
     C                   EVAL      DDEXCD3 = WTEXCD3
 
      ** Backup WHT Applicable Y/N 3
 
     C                   EVAL      DDBCWA3 = WTBCWA3
 
      ** Recipient Code3
 
     C                   EVAL      DDRPCD3 = WTRPCD3
 
      ** Tax Basket3
 
     C                   EVAL      DDTXBS3 = WTTXBS3
 
      ** Report Foreign Source Income Y/N 3
 
     C                   EVAL      DDRFSI3 = WTRFSI3
 
      ** Double Tax Treaty Y/N 3
 
     C                   EVAL      DDDBTT3 = WTDBTT3
 
      ** Tax Identification Number3
 
     C                   EVAL      DDTIN3  = WTTIN3
 
      ** Country of Tax Treaty4
 
     C                   EVAL      DDCRTT4 = WTCRTT4
 
      ** Intermediary Status4
 
     C                   EVAL      DDINTS4 = WTINTS4
 
      ** Documentation Received4
 
     C                   EVAL      DDDCRC4 = WTDCRC4
 
      ** Documentation Expiry Date4
 
     C                   IF        WTDCEX4 = *ZERO
     C                   EVAL      DDDCEX4 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX4
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX4 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX4
     C                   ENDIF
 
      ** Exemption Code4
 
     C                   EVAL      DDEXCD4 = WTEXCD4
 
      ** Backup WHT Applicable Y/N 4
 
     C                   EVAL      DDBCWA4 = WTBCWA4
 
      ** Recipient Code4
 
     C                   EVAL      DDRPCD4 = WTRPCD4
 
      ** Tax Basket4
 
     C                   EVAL      DDTXBS4 = WTTXBS4
 
      ** Report Foreign Source Income Y/N 4
 
     C                   EVAL      DDRFSI4 = WTRFSI4
 
      ** Double Tax Treaty Y/N 4
 
     C                   EVAL      DDDBTT4 = WTDBTT4
 
      ** Tax Identification Number4
 
     C                   EVAL      DDTIN4  = WTTIN4
 
      ** Country of Tax Treaty5
 
     C                   EVAL      DDCRTT5 = WTCRTT5
 
      ** Intermediary Status5
 
     C                   EVAL      DDINTS5 = WTINTS5
 
      ** Documentation Received5
 
     C                   EVAL      DDDCRC5 = WTDCRC5
 
      ** Documentation Expiry Date5
 
     C                   IF        WTDCEX5 = *ZERO
     C                   EVAL      DDDCEX5 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX5
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX5 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX5
     C                   ENDIF
 
      ** Exemption Code5
 
     C                   EVAL      DDEXCD5 = WTEXCD5
 
      ** Backup WHT Applicable Y/N 5
 
     C                   EVAL      DDBCWA5 = WTBCWA5
 
      ** Recipient Code5
 
     C                   EVAL      DDRPCD5 = WTRPCD5
 
      ** Tax Basket5
 
     C                   EVAL      DDTXBS5 = WTTXBS5
 
      ** Report Foreign Source Income Y/N 5
 
     C                   EVAL      DDRFSI5 = WTRFSI5
 
      ** Double Tax Treaty Y/N 5
 
     C                   EVAL      DDDBTT5 = WTDBTT5
 
      ** Tax Identification Number5
 
     C                   EVAL      DDTIN5  = WTTIN5
 
      ** Country of Tax Treaty6
 
     C                   EVAL      DDCRTT6 = WTCRTT6
 
      ** Intermediary Status6
 
     C                   EVAL      DDINTS6 = WTINTS6
 
      ** Documentation Received6
 
     C                   EVAL      DDDCRC6 = WTDCRC6
 
      ** Documentation Expiry Date6
 
     C                   IF        WTDCEX6 = *ZERO
     C                   EVAL      DDDCEX6 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX6
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX6 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX6
     C                   ENDIF
 
      ** Exemption Code6
 
     C                   EVAL      DDEXCD6 = WTEXCD6
 
      ** Backup WHT Applicable Y/N 6
 
     C                   EVAL      DDBCWA6 = WTBCWA6
 
      ** Recipient Code6
 
     C                   EVAL      DDRPCD6 = WTRPCD6
 
      ** Tax Basket6
 
     C                   EVAL      DDTXBS6 = WTTXBS6
 
      ** Report Foreign Source Income Y/N 6
 
     C                   EVAL      DDRFSI6 = WTRFSI6
 
      ** Double Tax Treaty Y/N 6
 
     C                   EVAL      DDDBTT6 = WTDBTT6
 
      ** Tax Identification Number6
 
     C                   EVAL      DDTIN6  = WTTIN6
 
      ** Country of Tax Treaty7
 
     C                   EVAL      DDCRTT7 = WTCRTT7
 
      ** Intermediary Status7
 
     C                   EVAL      DDINTS7 = WTINTS7
 
      ** Documentation Received7
 
     C                   EVAL      DDDCRC7 = WTDCRC7
 
      ** Documentation Expiry Date7
 
     C                   IF        WTDCEX7 = *ZERO
     C                   EVAL      DDDCEX7 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX7
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX7 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX7
     C                   ENDIF
 
      ** Exemption Code7
 
     C                   EVAL      DDEXCD7 = WTEXCD7
 
      ** Backup WHT Applicable Y/N 7
 
     C                   EVAL      DDBCWA7 = WTBCWA7
 
      ** Recipient Code7
 
     C                   EVAL      DDRPCD7 = WTRPCD7
 
      ** Tax Basket7
 
     C                   EVAL      DDTXBS7 = WTTXBS7
 
      ** Report Foreign Source Income Y/N 7
 
     C                   EVAL      DDRFSI7 = WTRFSI7
 
      ** Double Tax Treaty Y/N 7
 
     C                   EVAL      DDDBTT7 = WTDBTT7
 
      ** Tax Identification Number7
 
     C                   EVAL      DDTIN7  = WTTIN7
 
      ** Country of Tax Treaty8
 
     C                   EVAL      DDCRTT8 = WTCRTT8
 
      ** Intermediary Status8
 
     C                   EVAL      DDINTS8 = WTINTS8
 
      ** Documentation Received8
 
     C                   EVAL      DDDCRC8 = WTDCRC8
 
      ** Documentation Expiry Date8
 
     C                   IF        WTDCEX8 = *ZERO
     C                   EVAL      DDDCEX8 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX8
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX8 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX8
     C                   ENDIF
 
      ** Exemption Code8
 
     C                   EVAL      DDEXCD8 = WTEXCD8
 
      ** Backup WHT Applicable Y/N 8
 
     C                   EVAL      DDBCWA8 = WTBCWA8
 
      ** Recipient Code8
 
     C                   EVAL      DDRPCD8 = WTRPCD8
 
      ** Tax Basket8
 
     C                   EVAL      DDTXBS8 = WTTXBS8
 
      ** Report Foreign Source Income Y/N 8
 
     C                   EVAL      DDRFSI8 = WTRFSI8
 
      ** Double Tax Treaty Y/N 8
 
     C                   EVAL      DDDBTT8 = WTDBTT8
 
      ** Tax Identification Number8
 
     C                   EVAL      DDTIN8  = WTTIN8
 
      ** Country of Tax Treaty9
 
     C                   EVAL      DDCRTT9 = WTCRTT9
 
      ** Intermediary Status9
 
     C                   EVAL      DDINTS9 = WTINTS9
 
      ** Documentation Received9
 
     C                   EVAL      DDDCRC9 = WTDCRC9
 
      ** Documentation Expiry Date9
 
     C                   IF        WTDCEX9 = *ZERO
     C                   EVAL      DDDCEX9 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX9
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX9 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX9
     C                   ENDIF
 
      ** Exemption Code9
 
     C                   EVAL      DDEXCD9 = WTEXCD9
 
      ** Backup WHT Applicable Y/N 9
 
     C                   EVAL      DDBCWA9 = WTBCWA9
 
      ** Recipient Code9
 
     C                   EVAL      DDRPCD9 = WTRPCD9
 
      ** Tax Basket9
 
     C                   EVAL      DDTXBS9 = WTTXBS9
 
      ** Report Foreign Source Income Y/N 9
 
     C                   EVAL      DDRFSI9 = WTRFSI9
 
      ** Double Tax Treaty Y/N 9
 
     C                   EVAL      DDDBTT9 = WTDBTT9
 
      ** Tax Identification Number9
 
     C                   EVAL      DDTIN9  = WTTIN9
 
      ** Country of Tax Treaty10
 
     C                   EVAL      DDCRTT10 = WTCRTT10
 
      ** Intermediary Status10
 
     C                   EVAL      DDINTS10 = WTINTS10
 
      ** Documentation Received10
 
     C                   EVAL      DDDCRC10 = WTDCRC10
 
      ** Documentation Expiry Date10
 
     C                   IF        WTDCEX10 = *ZERO
     C                   EVAL      DDDCEX10 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX10
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX10 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX10
     C                   ENDIF
 
      ** Exemption Code10
 
     C                   EVAL      DDEXCD10 = WTEXCD10
 
      ** Backup WHT Applicable Y/N 10
 
     C                   EVAL      DDBCWA10 = WTBCWA10
 
      ** Recipient Code10
 
     C                   EVAL      DDRPCD10 = WTRPCD10
 
      ** Tax Basket10
 
     C                   EVAL      DDTXBS10 = WTTXBS10
 
      ** Report Foreign Source Income Y/N 10
 
     C                   EVAL      DDRFSI10 = WTRFSI10
 
      ** Double Tax Treaty Y/N 10
 
     C                   EVAL      DDDBTT10 = WTDBTT10
 
      ** Tax Identification Number10
 
     C                   EVAL      DDTIN10  = WTTIN10
 
      ** Country of Tax Treaty11
 
     C                   EVAL      DDCRTT11 = WTCRTT11
 
      ** Intermediary Status11
 
     C                   EVAL      DDINTS11 = WTINTS11
 
      ** Documentation Received11
 
     C                   EVAL      DDDCRC11 = WTDCRC11
 
      ** Documentation Expiry Date11
 
     C                   IF        WTDCEX11 = *ZERO
     C                   EVAL      DDDCEX11 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX11
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX11 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX11
     C                   ENDIF
 
      ** Exemption Code11
 
     C                   EVAL      DDEXCD11 = WTEXCD11
 
      ** Backup WHT Applicable Y/N 11
 
     C                   EVAL      DDBCWA11 = WTBCWA11
 
      ** Recipient Code11
 
     C                   EVAL      DDRPCD11 = WTRPCD11
 
      ** Tax Basket11
 
     C                   EVAL      DDTXBS11 = WTTXBS11
 
      ** Report Foreign Source Income Y/N 11
 
     C                   EVAL      DDRFSI11 = WTRFSI11
 
      ** Double Tax Treaty Y/N 11
 
     C                   EVAL      DDDBTT11 = WTDBTT11
 
      ** Tax Identification Number11
 
     C                   EVAL      DDTIN11  = WTTIN11
 
      ** Country of Tax Treaty12
 
     C                   EVAL      DDCRTT12 = WTCRTT12
 
      ** Intermediary Status12
 
     C                   EVAL      DDINTS12 = WTINTS12
 
      ** Documentation Received12
 
     C                   EVAL      DDDCRC12 = WTDCRC12
 
      ** Documentation Expiry Date12
 
     C                   IF        WTDCEX12 = *ZERO
     C                   EVAL      DDDCEX12 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX12
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX12 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX12
     C                   ENDIF
 
      ** Exemption Code12
 
     C                   EVAL      DDEXCD12 = WTEXCD12
 
      ** Backup WHT Applicable Y/N 12
 
     C                   EVAL      DDBCWA12 = WTBCWA12
 
      ** Recipient Code12
 
     C                   EVAL      DDRPCD12 = WTRPCD12
 
      ** Tax Basket12
 
     C                   EVAL      DDTXBS12 = WTTXBS12
 
      ** Report Foreign Source Income Y/N 12
 
     C                   EVAL      DDRFSI12 = WTRFSI12
 
      ** Double Tax Treaty Y/N 12
 
     C                   EVAL      DDDBTT12 = WTDBTT12
 
      ** Tax Identification Number12
 
     C                   EVAL      DDTIN12  = WTTIN12
 
      ** Country of Tax Treaty13
 
     C                   EVAL      DDCRTT13 = WTCRTT13
 
      ** Intermediary Status13
 
     C                   EVAL      DDINTS13 = WTINTS13
 
      ** Documentation Received13
 
     C                   EVAL      DDDCRC13 = WTDCRC13
 
      ** Documentation Expiry Date13
 
     C                   IF        WTDCEX13 = *ZERO
     C                   EVAL      DDDCEX13 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX13
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX13 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX13
     C                   ENDIF
 
      ** Exemption Code13
 
     C                   EVAL      DDEXCD13 = WTEXCD13
 
      ** Backup WHT Applicable Y/N 13
 
     C                   EVAL      DDBCWA13 = WTBCWA13
 
      ** Recipient Code13
 
     C                   EVAL      DDRPCD13 = WTRPCD13
 
      ** Tax Basket13
 
     C                   EVAL      DDTXBS13 = WTTXBS13
 
      ** Report Foreign Source Income Y/N 13
 
     C                   EVAL      DDRFSI13 = WTRFSI13
 
      ** Double Tax Treaty Y/N 13
 
     C                   EVAL      DDDBTT13 = WTDBTT13
 
      ** Tax Identification Number13
 
     C                   EVAL      DDTIN13  = WTTIN13
 
      ** Country of Tax Treaty14
 
     C                   EVAL      DDCRTT14 = WTCRTT14
 
      ** Intermediary Status14
 
     C                   EVAL      DDINTS14 = WTINTS14
 
      ** Documentation Received14
 
     C                   EVAL      DDDCRC14 = WTDCRC14
 
      ** Documentation Expiry Date14
 
     C                   IF        WTDCEX14 = *ZERO
     C                   EVAL      DDDCEX14 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX14
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX14 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX14
     C                   ENDIF
 
      ** Exemption Code14
 
     C                   EVAL      DDEXCD14 = WTEXCD14
 
      ** Backup WHT Applicable Y/N 14
 
     C                   EVAL      DDBCWA14 = WTBCWA14
 
      ** Recipient Code14
 
     C                   EVAL      DDRPCD14 = WTRPCD14
 
      ** Tax Basket14
 
     C                   EVAL      DDTXBS14 = WTTXBS14
 
      ** Report Foreign Source Income Y/N 14
 
     C                   EVAL      DDRFSI14 = WTRFSI14
 
      ** Double Tax Treaty Y/N 14
 
     C                   EVAL      DDDBTT14 = WTDBTT14
 
      ** Tax Identification Number14
 
     C                   EVAL      DDTIN14  = WTTIN14
 
      ** Country of Tax Treaty15
 
     C                   EVAL      DDCRTT15 = WTCRTT15
 
      ** Intermediary Status15
 
     C                   EVAL      DDINTS15 = WTINTS15
 
      ** Documentation Received15
 
     C                   EVAL      DDDCRC15 = WTDCRC15
 
      ** Documentation Expiry Date15
 
     C                   IF        WTDCEX15 = *ZERO
     C                   EVAL      DDDCEX15 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX15
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX15 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX15
     C                   ENDIF
 
      ** Exemption Code15
 
     C                   EVAL      DDEXCD15 = WTEXCD15
 
      ** Backup WHT Applicable Y/N 15
 
     C                   EVAL      DDBCWA15 = WTBCWA15
 
      ** Recipient Code15
 
     C                   EVAL      DDRPCD15 = WTRPCD15
 
      ** Tax Basket15
 
     C                   EVAL      DDTXBS15 = WTTXBS15
 
      ** Report Foreign Source Income Y/N 15
 
     C                   EVAL      DDRFSI15 = WTRFSI15
 
      ** Double Tax Treaty Y/N 15
 
     C                   EVAL      DDDBTT15 = WTDBTT15
 
      ** Tax Identification Number15
 
     C                   EVAL      DDTIN15  = WTTIN15
 
      ** Country of Tax Treaty16
 
     C                   EVAL      DDCRTT16 = WTCRTT16
 
      ** Intermediary Status16
 
     C                   EVAL      DDINTS16 = WTINTS16
 
      ** Documentation Received16
 
     C                   EVAL      DDDCRC16 = WTDCRC16
 
      ** Documentation Expiry Date16
 
     C                   IF        WTDCEX16 = *ZERO
     C                   EVAL      DDDCEX16 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX16
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX16 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX16
     C                   ENDIF
 
      ** Exemption Code16
 
     C                   EVAL      DDEXCD16 = WTEXCD16
 
      ** Backup WHT Applicable Y/N 16
 
     C                   EVAL      DDBCWA16 = WTBCWA16
 
      ** Recipient Code16
 
     C                   EVAL      DDRPCD16 = WTRPCD16
 
      ** Tax Basket16
 
     C                   EVAL      DDTXBS16 = WTTXBS16
 
      ** Report Foreign Source Income Y/N 16
 
     C                   EVAL      DDRFSI16 = WTRFSI16
 
      ** Double Tax Treaty Y/N 16
 
     C                   EVAL      DDDBTT16 = WTDBTT16
 
      ** Tax Identification Number16
 
     C                   EVAL      DDTIN16  = WTTIN16
 
      ** Country of Tax Treaty17
 
     C                   EVAL      DDCRTT17 = WTCRTT17
 
      ** Intermediary Status17
 
     C                   EVAL      DDINTS17 = WTINTS17
 
      ** Documentation Received17
 
     C                   EVAL      DDDCRC17 = WTDCRC17
 
      ** Documentation Expiry Date17
 
     C                   IF        WTDCEX17 = *ZERO
     C                   EVAL      DDDCEX17 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX17
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX17 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX17
     C                   ENDIF
 
      ** Exemption Code17
 
     C                   EVAL      DDEXCD17 = WTEXCD17
 
      ** Backup WHT Applicable Y/N 17
 
     C                   EVAL      DDBCWA17 = WTBCWA17
 
      ** Recipient Code17
 
     C                   EVAL      DDRPCD17 = WTRPCD17
 
      ** Tax Basket17
 
     C                   EVAL      DDTXBS17 = WTTXBS17
 
      ** Report Foreign Source Income Y/N 17
 
     C                   EVAL      DDRFSI17 = WTRFSI17
 
      ** Double Tax Treaty Y/N 17
 
     C                   EVAL      DDDBTT17 = WTDBTT17
 
      ** Tax Identification Number17
 
     C                   EVAL      DDTIN17  = WTTIN17
 
      ** Country of Tax Treaty18
 
     C                   EVAL      DDCRTT18 = WTCRTT18
 
      ** Intermediary Status18
 
     C                   EVAL      DDINTS18 = WTINTS18
 
      ** Documentation Received18
 
     C                   EVAL      DDDCRC18 = WTDCRC18
 
      ** Documentation Expiry Date18
 
     C                   IF        WTDCEX18 = *ZERO
     C                   EVAL      DDDCEX18 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX18
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX18 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX18
     C                   ENDIF
 
      ** Exemption Code18
 
     C                   EVAL      DDEXCD18 = WTEXCD18
 
      ** Backup WHT Applicable Y/N 18
 
     C                   EVAL      DDBCWA18 = WTBCWA18
 
      ** Recipient Code18
 
     C                   EVAL      DDRPCD18 = WTRPCD18
 
      ** Tax Basket18
 
     C                   EVAL      DDTXBS18 = WTTXBS18
 
      ** Report Foreign Source Income Y/N 18
 
     C                   EVAL      DDRFSI18 = WTRFSI18
 
      ** Double Tax Treaty Y/N 18
 
     C                   EVAL      DDDBTT18 = WTDBTT18
 
      ** Tax Identification Number18
 
     C                   EVAL      DDTIN18  = WTTIN18
 
      ** Country of Tax Treaty19
 
     C                   EVAL      DDCRTT19 = WTCRTT19
 
      ** Intermediary Status19
 
     C                   EVAL      DDINTS19 = WTINTS19
 
      ** Documentation Received19
 
     C                   EVAL      DDDCRC19 = WTDCRC19
 
      ** Documentation Expiry Date19
 
     C                   IF        WTDCEX19 = *ZERO
     C                   EVAL      DDDCEX19 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX19
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX19 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX19
     C                   ENDIF
 
      ** Exemption Code19
 
     C                   EVAL      DDEXCD19 = WTEXCD19
 
      ** Backup WHT Applicable Y/N 19
 
     C                   EVAL      DDBCWA19 = WTBCWA19
 
      ** Recipient Code19
 
     C                   EVAL      DDRPCD19 = WTRPCD19
 
      ** Tax Basket19
 
     C                   EVAL      DDTXBS19 = WTTXBS19
 
      ** Report Foreign Source Income Y/N 19
 
     C                   EVAL      DDRFSI19 = WTRFSI19
 
      ** Double Tax Treaty Y/N 19
 
     C                   EVAL      DDDBTT19 = WTDBTT19
 
      ** Tax Identification Number19
 
     C                   EVAL      DDTIN19  = WTTIN19
 
      ** Country of Tax Treaty20
 
     C                   EVAL      DDCRTT20 = WTCRTT20
 
      ** Intermediary Status20
 
     C                   EVAL      DDINTS20 = WTINTS20
 
      ** Documentation Received20
 
     C                   EVAL      DDDCRC20 = WTDCRC20
 
      ** Documentation Expiry Date20
 
     C                   IF        WTDCEX20 = *ZERO
     C                   EVAL      DDDCEX20 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX20
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX20 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX20
     C                   ENDIF
 
      ** Exemption Code20
 
     C                   EVAL      DDEXCD20 = WTEXCD20
 
      ** Backup WHT Applicable Y/N 20
 
     C                   EVAL      DDBCWA20 = WTBCWA20
 
      ** Recipient Code20
 
     C                   EVAL      DDRPCD20 = WTRPCD20
 
      ** Tax Basket20
 
     C                   EVAL      DDTXBS20 = WTTXBS20
 
      ** Report Foreign Source Income Y/N 20
 
     C                   EVAL      DDRFSI20 = WTRFSI20
 
      ** Double Tax Treaty Y/N 20
 
     C                   EVAL      DDDBTT20 = WTDBTT20
 
      ** Tax Identification Number20
 
     C                   EVAL      DDTIN20  = WTTIN20
 
      ** Country of Tax Treaty21
 
     C                   EVAL      DDCRTT21 = WTCRTT21
 
      ** Intermediary Status21
 
     C                   EVAL      DDINTS21 = WTINTS21
 
      ** Documentation Received21
 
     C                   EVAL      DDDCRC21 = WTDCRC21
 
      ** Documentation Expiry Date21
 
     C                   IF        WTDCEX21 = *ZERO
     C                   EVAL      DDDCEX21 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX21
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX21 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX21
     C                   ENDIF
 
      ** Exemption Code21
 
     C                   EVAL      DDEXCD21 = WTEXCD21
 
      ** Backup WHT Applicable Y/N 21
 
     C                   EVAL      DDBCWA21 = WTBCWA21
 
      ** Recipient Code21
 
     C                   EVAL      DDRPCD21 = WTRPCD21
 
      ** Tax Basket21
 
     C                   EVAL      DDTXBS21 = WTTXBS21
 
      ** Report Foreign Source Income Y/N 21
 
     C                   EVAL      DDRFSI21 = WTRFSI21
 
      ** Double Tax Treaty Y/N 21
 
     C                   EVAL      DDDBTT21 = WTDBTT21
 
      ** Tax Identification Number21
 
     C                   EVAL      DDTIN21  = WTTIN21
 
      ** Country of Tax Treaty22
 
     C                   EVAL      DDCRTT22 = WTCRTT22
 
      ** Intermediary Status22
 
     C                   EVAL      DDINTS22 = WTINTS22
 
      ** Documentation Received22
 
     C                   EVAL      DDDCRC22 = WTDCRC22
 
      ** Documentation Expiry Date22
 
     C                   IF        WTDCEX22 = *ZERO
     C                   EVAL      DDDCEX22 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX22
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX22 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX22
     C                   ENDIF
 
      ** Exemption Code 22
 
     C                   EVAL      DDEXCD22 = WTEXCD22
 
      ** Backup WHT Applicable Y/N 22
 
     C                   EVAL      DDBCWA22 = WTBCWA22
 
      ** Recipient Code22
 
     C                   EVAL      DDRPCD22 = WTRPCD22
 
      ** Tax Basket22
 
     C                   EVAL      DDTXBS22 = WTTXBS22
 
      ** Report Foreign Source Income Y/N 22
 
     C                   EVAL      DDRFSI22 = WTRFSI22
 
      ** Double Tax Treaty Y/N 22
 
     C                   EVAL      DDDBTT22 = WTDBTT22
 
      ** Tax Identification Number22
 
     C                   EVAL      DDTIN22  = WTTIN22
 
      ** Country of Tax Treaty23
 
     C                   EVAL      DDCRTT23 = WTCRTT23
 
      ** Intermediary Status23
 
     C                   EVAL      DDINTS23 = WTINTS23
 
      ** Documentation Received23
 
     C                   EVAL      DDDCRC23 = WTDCRC23
 
      ** Documentation Expiry Date23
 
     C                   IF        WTDCEX23 = *ZERO
     C                   EVAL      DDDCEX23 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX23
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX23 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX23
     C                   ENDIF
 
      ** Exemption Code23
 
     C                   EVAL      DDEXCD23 = WTEXCD23
 
      ** Backup WHT Applicable Y/N 23
 
     C                   EVAL      DDBCWA23 = WTBCWA23
 
      ** Recipient Code23
 
     C                   EVAL      DDRPCD23 = WTRPCD23
 
      ** Tax Basket23
 
     C                   EVAL      DDTXBS23 = WTTXBS23
 
      ** Report Foreign Source Income Y/N 23
 
     C                   EVAL      DDRFSI23 = WTRFSI23
 
      ** Double Tax Treaty Y/N 23
 
     C                   EVAL      DDDBTT23 = WTDBTT23
 
      ** Tax Identification Number23
 
     C                   EVAL      DDTIN23  = WTTIN23
 
      ** Country of Tax Treaty24
 
     C                   EVAL      DDCRTT24 = WTCRTT24
 
      ** Intermediary Status24
 
     C                   EVAL      DDINTS24 = WTINTS24
 
      ** Documentation Received24
 
     C                   EVAL      DDDCRC24 = WTDCRC24
 
      ** Documentation Expiry Date24
 
     C                   IF        WTDCEX24 = *ZERO
     C                   EVAL      DDDCEX24 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX24
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX24 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX24
     C                   ENDIF
 
      ** Exemption Code24
 
     C                   EVAL      DDEXCD24 = WTEXCD24
 
      ** Backup WHT Applicable Y/N 24
 
     C                   EVAL      DDBCWA24 = WTBCWA24
 
      ** Recipient Code24
 
     C                   EVAL      DDRPCD24 = WTRPCD24
 
      ** Tax Basket24
 
     C                   EVAL      DDTXBS24 = WTTXBS24
 
      ** Report Foreign Source Income Y/N 24
 
     C                   EVAL      DDRFSI24 = WTRFSI24
 
      ** Double Tax Treaty Y/N 24
 
     C                   EVAL      DDDBTT24 = WTDBTT24
 
      ** Tax Identification Number24
 
     C                   EVAL      DDTIN24  = WTTIN24
 
      ** Country of Tax Treaty25
 
     C                   EVAL      DDCRTT25 = WTCRTT25
 
      ** Intermediary Status25
 
     C                   EVAL      DDINTS25 = WTINTS25
 
      ** Documentation Received25
 
     C                   EVAL      DDDCRC25 = WTDCRC25
 
      ** Documentation Expiry Date25
 
     C                   IF        WTDCEX25 = *ZERO
     C                   EVAL      DDDCEX25 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX25
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX25 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX25
     C                   ENDIF
 
      ** Exemption Code25
 
     C                   EVAL      DDEXCD25 = WTEXCD25
 
      ** Backup WHT Applicable Y/N 25
 
     C                   EVAL      DDBCWA25 = WTBCWA25
 
      ** Recipient Code25
 
     C                   EVAL      DDRPCD25 = WTRPCD25
 
      ** Tax Basket25
 
     C                   EVAL      DDTXBS25 = WTTXBS25
 
      ** Report Foreign Source Income Y/N 25
 
     C                   EVAL      DDRFSI25 = WTRFSI25
 
      ** Double Tax Treaty Y/N 25
 
     C                   EVAL      DDDBTT25 = WTDBTT25
 
      ** Tax Identification Number25
 
     C                   EVAL      DDTIN25  = WTTIN25
 
      ** Country of Tax Treaty26
 
     C                   EVAL      DDCRTT26 = WTCRTT26
 
      ** Intermediary Status26
 
     C                   EVAL      DDINTS26 = WTINTS26
 
      ** Documentation Received26
 
     C                   EVAL      DDDCRC26 = WTDCRC26
 
      ** Documentation Expiry Date26
 
     C                   IF        WTDCEX26 = *ZERO
     C                   EVAL      DDDCEX26 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX26
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX26 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX26
     C                   ENDIF
 
      ** Exemption Code26
 
     C                   EVAL      DDEXCD26 = WTEXCD26
 
      ** Backup WHT Applicable Y/N 26
 
     C                   EVAL      DDBCWA26 = WTBCWA26
 
      ** Recipient Code26
 
     C                   EVAL      DDRPCD26 = WTRPCD26
 
      ** Tax Basket26
 
     C                   EVAL      DDTXBS26 = WTTXBS26
 
      ** Report Foreign Source Income Y/N 26
 
     C                   EVAL      DDRFSI26 = WTRFSI26
 
      ** Double Tax Treaty Y/N 26
 
     C                   EVAL      DDDBTT26 = WTDBTT26
 
      ** Tax Identification Number26
 
     C                   EVAL      DDTIN26  = WTTIN26
 
      ** Country of Tax Treaty27
 
     C                   EVAL      DDCRTT27 = WTCRTT27
 
      ** Intermediary Status27
 
     C                   EVAL      DDINTS27 = WTINTS27
 
      ** Documentation Received27
 
     C                   EVAL      DDDCRC27 = WTDCRC27
 
      ** Documentation Expiry Date27
 
     C                   IF        WTDCEX27 = *ZERO
     C                   EVAL      DDDCEX27 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX27
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX27 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX27
     C                   ENDIF
 
      ** Exemption Code27
 
     C                   EVAL      DDEXCD27 = WTEXCD27
 
      ** Backup WHT Applicable Y/N 27
 
     C                   EVAL      DDBCWA27 = WTBCWA27
 
      ** Recipient Code27
 
     C                   EVAL      DDRPCD27 = WTRPCD27
 
      ** Tax Basket27
 
     C                   EVAL      DDTXBS27 = WTTXBS27
 
      ** Report Foreign Source Income Y/N 27
 
     C                   EVAL      DDRFSI27 = WTRFSI27
 
      ** Double Tax Treaty Y/N 27
 
     C                   EVAL      DDDBTT27 = WTDBTT27
 
      ** Tax Identification Number27
 
     C                   EVAL      DDTIN27  = WTTIN27
 
      ** Country of Tax Treaty28
 
     C                   EVAL      DDCRTT28 = WTCRTT28
 
      ** Intermediary Status28
 
     C                   EVAL      DDINTS28 = WTINTS28
 
      ** Documentation Received28
 
     C                   EVAL      DDDCRC28 = WTDCRC28
 
      ** Documentation Expiry Date28
 
     C                   IF        WTDCEX28 = *ZERO
     C                   EVAL      DDDCEX28 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX28
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX28 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX28
     C                   ENDIF
 
      ** Exemption Code28
 
     C                   EVAL      DDEXCD28 = WTEXCD28
 
      ** Backup WHT Applicable Y/N 28
 
     C                   EVAL      DDBCWA28 = WTBCWA28
 
      ** Recipient Code28
 
     C                   EVAL      DDRPCD28 = WTRPCD28
 
      ** Tax Basket28
 
     C                   EVAL      DDTXBS28 = WTTXBS28
 
      ** Report Foreign Source Income Y/N 28
 
     C                   EVAL      DDRFSI28 = WTRFSI28
 
      ** Double Tax Treaty Y/N 28
 
     C                   EVAL      DDDBTT28 = WTDBTT28
 
      ** Tax Identification Number28
 
     C                   EVAL      DDTIN28  = WTTIN28
 
      ** Country of Tax Treaty29
 
     C                   EVAL      DDCRTT29 = WTCRTT29
 
      ** Intermediary Status29
 
     C                   EVAL      DDINTS29 = WTINTS29
 
      ** Documentation Received29
 
     C                   EVAL      DDDCRC29 = WTDCRC29
 
      ** Documentation Expiry Date29
 
     C                   IF        WTDCEX29 = *ZERO
     C                   EVAL      DDDCEX29 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX29
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX29 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX29
     C                   ENDIF
 
      ** Exemption Code29
 
     C                   EVAL      DDEXCD29 = WTEXCD29
 
      ** Backup WHT Applicable Y/N 29
 
     C                   EVAL      DDBCWA29 = WTBCWA29
 
      ** Recipient Code29
 
     C                   EVAL      DDRPCD29 = WTRPCD29
 
      ** Tax Basket29
 
     C                   EVAL      DDTXBS29 = WTTXBS29
 
      ** Report Foreign Source Income Y/N 29
 
     C                   EVAL      DDRFSI29 = WTRFSI29
 
      ** Double Tax Treaty Y/N 29
 
     C                   EVAL      DDDBTT29 = WTDBTT29
 
      ** Tax Identification Number29
 
     C                   EVAL      DDTIN29  = WTTIN29
 
      ** Country of Tax Treaty30
 
     C                   EVAL      DDCRTT30 = WTCRTT30
 
      ** Intermediary Status30
 
     C                   EVAL      DDINTS30 = WTINTS30
 
      ** Documentation Received30
 
     C                   EVAL      DDDCRC30 = WTDCRC30
 
      ** Documentation Expiry Date30
 
     C                   IF        WTDCEX30 = *ZERO
     C                   EVAL      DDDCEX30 = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = WTDCEX30
     C                   EXSR      ZDATE2
     C                   EVAL      DDDCEX30 = *BLANKS
     C                   MOVEL     ZDATE         DDDCEX30
     C                   ENDIF
 
      ** Exemption Code30
 
     C                   EVAL      DDEXCD30 = WTEXCD30
 
      ** Backup WHT Applicable Y/N 30
 
     C                   EVAL      DDBCWA30 = WTBCWA30
 
      ** Recipient Code30
 
     C                   EVAL      DDRPCD30 = WTRPCD30
 
      ** Tax Basket30
 
     C                   EVAL      DDTXBS30 = WTTXBS30
 
      ** Report Foreign Source Income Y/N 30
 
     C                   EVAL      DDRFSI30 = WTRFSI30
 
      ** Double Tax Treaty Y/N 30
 
     C                   EVAL      DDDBTT30 = WTDBTT30
 
      ** Tax Identification Number30
 
     C                   EVAL      DDTIN30  = WTTIN30
 
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
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
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
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
 
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
(c) Misys International Banking Systems Ltd. 2007
