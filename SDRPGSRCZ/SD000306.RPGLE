     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Indicia Search Tool')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000306  - Midas SD CRS Indicia Search Tool                 *
      *                                                               *
      *  Function:  This module allows the user to create criterion   *
      *             to update subject to reporting flag based on the  *
      *             Indicia search. The tool runs in Information and  *
      *             Update modes.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSD000306DFCF   E             WORKSTN
     F                                     SFILE(SD000306S0:DDSFRN)

      ** Midas SD CRS Criteria Table
     FSDCCLSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN

      ** Midas SD CRS Criteria Table
     FSDCCLSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCCLSD0:SDCCLSD1)
     F                                     USROPN

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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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


      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** QCMDEXC Table
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV4           S             50    DIM(1) CTDATA PERRCD(1)

      * Current Selection Fields
     D @BDSFL          S              1A
     D @RTCDL          S              7A
     D @OPTNL          S              7A
     D WChange         S              1A
     D WError          S              1A
     D DDSFRN          S              4S 0
     D WPos            S              4S 0
     D WErrCnt         S              4S 0 INZ(0)
     D WValRecs        S              4S 0 INZ(0)
     D PMode           S              1A
     D PZMsgFile       S             10A   INZ(*BLANKS)
     D PZMsgID         S             10A
     D PZMsgData       S             45A
     D WBlanksOnly     S              1A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
     D DDPGMQ          S             10A
     D WLeave          S              1A
     D WCtr            S              1S 0
     D ZAPGRL          S              5A
     D PReturn         S              7A

     D P@Rtcd          S              7A
     D P@Optn          S              7A
     D P@CLAS          S              5A
     D P@FMT         E DS                  EXTNAME(SDFATCPD)

     D WMsgLen         S             15P 5 INZ(50)

     D PType           S              5A
     D KClas           S              5A
     D KCSTY           S              1A
     D WACTN           S              1A
     D WFirstScr       S              1A   INZ('N')
     D WDelete         S              1A
     D WNoData         S              1A   INZ('Y')
     D WWrite          S              1A   INZ(' ')
     D WUpdate         S              1A   INZ('N')
     D WLockF          S              1A   INZ(' ')
     D PInfoRanF       S              1A   INZ(' ')
     D PUpdatRanF      S              1A   INZ(' ')
     D PUpdat2         S              1A   INZ('N')
     D PRtcd           S              7A
     D PCallerPGM      S             10A
     D PModeLck        S              7A


     DWCurrInput       DS
     D  D0CSTY


     DWPrevInput       DS
     D  PRCSTY                             LIKE(D0CSTY)


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** BUILD Sub-file
     C                   EXSR      SrPrcSFL

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPrcSFL - Process Subfile Actions                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRInitSFL, SrBldSFL, ZA0250, SDC000307, SDC000308
      *                                                               *
      *****************************************************************

     C     SrPrcSFL      BEGSR

     C                   OPEN      SDCCLSL0
     C                   OPEN      SDCCLSL1

     C                   DOW       NOT *INKC

     C                   EXSR      SrInitSFL
     C                   EXSR      SrBldSFL

     C                   WRITE     SD000306C1
     C                   WRITE     SD000306F1
     C                   EXFMT     SD000306C0

      ** Clear program message queue
     C                   CALL      'ZA0250'

     C                   SELECT

     C                   WHEN      *INKI = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SrProcACTN

     C                   IF        WError <> 'Y'
     C                             AND WWrite <> 'N'
     C                   EVAL      DPFCTP = D0CSTY

     C                   WRITE     SDCCLSD0
     C                   ENDIF

     C                   ITER

      ** Run Tool in Information Mode
     C                   WHEN      *INKK = *ON

     C                   CLOSE     SDCCLSL0
     C                   CLOSE     SDCCLSL1

     C                   CALL      'SDC000307'
     C                   PARM      *Blanks       PReturn
     C                   PARM      'N'           PUpdat2
     C                   PARM      *Blanks       PType

     C                   EVAL      PInfoRanF = 'Y'

     C                   IF        *INU7 = *ON OR *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   OPEN      SDCCLSL0
     C                   OPEN      SDCCLSL1

     C                   CALL      'SDC000308'
     C                   PARM      'I'           PMode
     C                   PARM                    PType

     C                   IF        *INU7 = *ON OR *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   EVAL      PZMsgID = 'USS0283'
     C                   EXSR      SRZasnms

      ** Run Tool in Update Mode
     C                   WHEN      *INKM = *ON

      ** Run Tool After Confirmation
     C                   IF        WUpdate = 'Y'

     C                   CLOSE     SDCCLSL0
     C                   CLOSE     SDCCLSL1

     C                   CALL      'SDC000307'
     C                   PARM      *Blanks       PReturn
     C                   PARM      'Y'           PUpdat2
     C                   PARM      *Blanks       PType

     C                   EVAL      PUpdatRanF = 'Y'

     C                   IF        *INU7 = *ON OR *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   OPEN      SDCCLSL0
     C                   OPEN      SDCCLSL1

     C                   CALL      'SDC000308'
     C                   PARM      ' '           PMode
     C                   PARM                    PType

     C                   IF        *INU7 = *ON OR *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV3
     C                   PARM                    WMsgLen

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV4
     C                   PARM                    WMsgLen

     C                   EVAL      WUpdate = ' '
     C                   EVAL      PZMsgID = 'USS0269'
     C                   EXSR      SRZasnms

     C                   ENDIF

     C                   IF        WUpdate = 'N'
     C                   EVAL      WLockF = 'Y'

     C                   CALL      'SDC000558'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      'SD000306'    PCallerPGM
     C                   PARM      '*LOCK'       PModeLck

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      PZMsgID = 'USS0320'
     C                   EXSR      SRZasnms
     C                   EVAL      WLockF = 'N'
     C                   ENDIF

     C                   IF        WLockF = 'Y'
     C                   EVAL      PZMsgID = 'USS0285'
     C                   EXSR      SRZasnms
     C                   EVAL      WUpdate = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   IF        WUpdate = ' '
     C                   EVAL      WUpdate = 'N'
     C                   ENDIF

     C                   WHEN      *INKC = *ON OR
     C                             *INKL = *ON

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV3
     C                   PARM                    WMsgLen

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV4
     C                   PARM                    WMsgLen

     C                   ITER
     C                   RETURN

      ** If tool has been run, call update and enquiry

     C                   WHEN      *INKK = *ON OR
     C                             *INKM = *ON

     C                   WHEN      *INKE = *ON

      ** Clear program message queue
     C                   CALL      'ZA0250'
     C                   EXSR      SrInitSFL
     C                   EXSR      SrBldSFL

      ** Rebuild subfile
     C                   ITER

      ** run tool

     C                   OTHER

     C                   IF        WNoData <> 'Y'
     C                   READC     SD000306S0

     C                   DOW       NOT %EOF
     C                   EVAL      WACTN = S1ACTN

      ** Only allow 'D' and 'E' action code.

     C                   IF        WACTN = 'D' OR
     C                             WACTN = 'E'
     C                   EXSR      SrProcACTN
     C                   ELSE
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0679'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   IF        WError <> 'Y'
     C                             AND WWrite <> 'N'

     C                   EVAL      DPFCTP = D0CSTY

     C                   ENDIF

     C                   EVAL      S1ACTN = *BLANKS
     C                   UPDATE    SD000306S0
     C                   READC     SD000306S0
     C                   ENDDO
     C                   ENDIF

     C                   ENDSL

     C                   ENDDO

     C                   CLOSE     SDCCLSL0
     C                   CLOSE     SDCCLSL1

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBldSFL - Build Initial Subfile                              *
      *                                                               *
      * Called by: SrPrcSFL                                           *
      *                                                               *
      * Calls: SRZasnms                                               *
      *                                                               *
      *****************************************************************

     C     SrBldSFL      BEGSR

     C                   EVAL      WNoData = 'Y'
     C                   EVAL      *IN94 = *ON
     C                   EVAL      *IN96 = *ON
     C                   EVAL      *IN98 = *ON

     C     *LOVAL        SETLL     SDCCLSL0
     C                   READ      SDCCLSL0

     C                   DOW       NOT %EOF(SDCCLSL0)

     C                   EVAL      S1CSTY = DPFCTP
     C                   EXSR      SrLoadDtls
     C                   EVAL      S1DESC = D0CSTD
     C                   EVAL      DDSFRN = DDSFRN + 1
     C                   WRITE     SD000306S0
     C                   EVAL      WNoData = 'N'
     C                   EVAL      *IN98 = *OFF
     C                   READ      SDCCLSL0

     C                   ENDDO

      ** At end of file set the subfile end = *on

     C                   EVAL      *IN96 = *ON
     C                   WRITE     SD000306C0

     C                   IF        DDSFRN = 0
     C                   EVAL      PZMsgID = 'ASM0001'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcACTN - Process actions taken on the subfile             *
      *                                                               *
      * Called by: SrPrcSFL                                           *
      *                                                               *
      * Calls: ZA0250, SrLoadDtls, SRZasnms, SrValDet                 *
      *                                                               *
      *****************************************************************

     C     SrProcACTN    BEGSR

      ** Clear program message queue
     C                   CALL      'ZA0250'

     C                   MOVEA     '000000'      *IN(60)
     C                   EVAL      *IN59 = *OFF
     C                   EVAL      WLeave = 'Y'

      ** If not on insert, obtain record
     C                   IF        WACTN <> 'I'
     C                   EXSR      SrLoadDtls
     C                   ELSE
     C                   EVAL      D0CSTY = *BLANKS
     C                   EVAL      D0CSTD = *BLANKS
     C                   ENDIF

     C                   IF        WACTN = 'I'

      ** Turn off Protect indicators
     C                   EVAL      *IN58 = *OFF
     C                   EVAL      *IN57 = *OFF
     C                   ELSE
     C                   EVAL      *IN57 = *ON
     C                   EVAL      *IN58 = *ON
     C                   ENDIF

     C                   IF        WACTN = 'D'

      ** Turn on F10 to delete
     C                   EVAL      *IN59 = *ON
     C                   EVAL      WDelete = 'Y'
     C                   EVAL      PZMsgID = 'ASM0028'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   EVAL      *INKL = *OFF

     C                   DOW       NOT *INKC
     C                             AND NOT *INKL

      ** Save Previous Input to check for changes
     C                   EVAL      WPrevInput = WCurrInput

     C                   WRITE     SD000306F2
     C                   WRITE     SD000306C1
     C                   EXFMT     SD000306D0

     C                   EVAL      WError = *BLANKS
     C                   EVAL      WWrite = *BLANKS

     C                   SELECT

     C                   WHEN      *INKL = *ON
     C                   EVAL      WWrite = 'N'
     C                   EVAL      WFirstScr = 'Y'
     C                   CALL      'ZA0250'
     C                   ITER

     C                   WHEN      *INKC = *ON
     C                   EVAL      WWrite = 'N'
     C                   ITER

     C                   OTHER

     C                   IF        *INKJ = *ON
     C                             AND WDelete = 'Y'
     C     D0CSTY        CHAIN     SDCCLSL0
     C                   DELETE    SDCCLSL0

     C                   CALL      'ZA0250'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        WCurrInput = WPrevInput
     C                             AND WCurrInput <> *BLANKS
     C                             AND WLeave = 'Y'
     C                   CALL      'ZA0250'
     C                   LEAVESR
     C                   ENDIF

     C                   EXSR      SrValDet

     C                   ENDSL

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValDet - Validate Details                                   *
      *                                                               *
      * Called by: SrProcACTN                                         *
      *                                                               *
      * Calls: ZA0250, SRZasnms                                       *
      *                                                               *
      *****************************************************************

     C     SrValDet      BEGSR

      ** Initialize to blanks

     C                   EVAL      *IN60 = *OFF
     C                   EVAL      *IN62 = *OFF
     C                   EVAL      *IN63 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      *IN65 = *OFF
     C                   CALL      'ZA0250'

      ** Validate Customer Type

     C                   SELECT
     C                   WHEN      D0CSTY = 'O'
     C                   EVAL      D0CSTD = 'Others'
     C                   WHEN      D0CSTY = 'F'
     C                   EVAL      D0CSTD = 'Financial Institution'
     C                   WHEN      D0CSTY = 'N'
     C                   EVAL      D0CSTD = 'Non-financial Entity'
     C                   WHEN      D0CSTY = 'P'
     C                   EVAL      D0CSTD = 'Physical Person'
     C                   WHEN      D0CSTY = 'J'
     C                   EVAL      D0CSTD = 'Joint Accounts'
     C                   WHEN      D0CSTY = '*'
     C                   EVAL      D0CSTD = 'ALL'

     C                   OTHER

     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0681'
     C                   EXSR      SRZasnms

     C                   ENDSL

      ** Check if input is already present
     C                   EVAL      KCSTY = D0CSTY

     C     KCSTY         CHAIN     SDCCLSL1
     C                   IF        %FOUND(SDCCLSL1)
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0680'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Check if *ALL is NOT allowed

     C     *LOVAL        SETLL     SDCCLSL1
     C                   READ      SDCCLSL1
     C                   IF        %FOUND(SDCCLSL1) AND
     C                             D0CSTY = '*'
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0675'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Check if input is not allowed because *ALL is present

     C                   EVAL      KCSTY = '*'

     C     KCSTY         CHAIN     SDCCLSL1
     C                   IF        %FOUND(SDCCLSL1)
     C                             AND D0CSTY <> *Blanks
     C                   EVAL      *IN64 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0677'
     C                   EXSR      SRZasnms
     C                   ENDIF

      ** Will not leave subroutine if error is occuring

     C                   IF        WError = 'Y'
     C                   EVAL      WLeave = 'N'
     C                   ELSE
     C                   EVAL      WLeave = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLoadDtls - Load Details if not doing insert                 *
      *                                                               *
      * Called by: SrProcACTN                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrLoadDtls    BEGSR

     C                   EVAL      D0CSTY = S1CSTY

     C                   SELECT
     C                   WHEN      D0CSTY = 'O'
     C                   EVAL      D0CSTD = 'Others'
     C                   WHEN      D0CSTY = 'F'
     C                   EVAL      D0CSTD = 'Financial Institution'
     C                   WHEN      D0CSTY = 'N'
     C                   EVAL      D0CSTD = 'Non-financial Entity'
     C                   WHEN      D0CSTY = 'P'
     C                   EVAL      D0CSTD = 'Physical Person'
     C                   WHEN      D0CSTY = 'J'
     C                   EVAL      D0CSTD = 'Joint Accounts'
     C                   WHEN      D0CSTY = '*'
     C                   EVAL      D0CSTD = 'ALL'
     C                   ENDSL

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInitSFL - INITIALIZATION                                    *
      *                                                               *
      * Called by: SrPrcSFL                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrInitSFL     BEGSR

     C                   Z-ADD     0             DDSFRN
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SD000306C0
     C                   EVAL      *IN97 = *OFF

     C                   EVAL      WError = 'N'
     C                   EVAL      *IN59 = *OFF

     C                   EVAL      WErrCnt = 0
     C                   EVAL      WValRecs = 0

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls    : ZA0350                                             *
      *                                                               *
      *****************************************************************

     C     SRZasnms      BEGSR

     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM      'SD000306'    PZMsgData

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Initialize program name
     C                   MOVEL     'SD000306'    DBPGM

      ** Move workstation ID to screen field.
     C                   EVAL      DDWID  = PsJobName
     C                   EVAL      DDPGMQ = PSProcName
     C                   EVAL      DDUSER = PsUser

     C                   MOVE      '1'           *IN94

      ** ACCESS BANK DETAILS

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** DATABASE ERROR

     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      DDDATE = BJMRDT

     C                   EVAL      PZMsgFile = 'SDUSRMSG'

     C                   EXSR      SrInitSFL

      ** Clear program message queue
     C                   CALL      'ZA0250'

     C                   ENDSR

      ********************************************************************
      **------------------------------------------------------------------

      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      ** OV1 to OV4 changed to *EXCL from *EXCLRD
**  CPY@
(c) Finastra International Limited 2016
** ##OV1
ALCOBJ OBJ((SDCRSDPD *FILE *EXCL)) WAIT(10)
** ##OV2
ALCOBJ OBJ((SDCRSNPD *FILE *EXCL)) WAIT(10)
** ##OV3
DLCOBJ OBJ((SDCRSDPD *FILE *EXCL))
** ##OV4
DLCOBJ OBJ((SDCRSNPD *FILE *EXCL))
