     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD FATCA Indicia Search Tool')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000730  - Midas SD FATCA Indicia Search Tool               *
      *                                                               *
      *  Function:  This module allows the user to create criterion   *
      *             to update Classification codes based on the       *
      *             Indicia search. The tool runs in Information and  *
      *             Update modes.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD025321           Date 16Sep14               *
      *                 MD027258           Date 05Aug14               *
      *                 MD027355A          Date 06Jun14               *
      *                 MD027360           Date 06Jun14               *
      *                 MD027172           Date 28May14               *
      *                 MD026650           Date 09May14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD025321 - Scroll Bar should be removed when there is only   *
      *             only 1 page of selection                          *
      *  MD027258 - Second screen becomes default on entry            *
      *  MD027355A - 'US Indicia Changed' header is not displayed     *
      *  MD027360 - No FATCA Classification changed is displayed      *
      *             upon running US Indicia tool                      *
      *  MD027172 - Cannot add criteria with Current Classification   *
      *             "*ALL"                                            *
      *  MD026650 - Applied fix MD025554                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD000730DFCF   E             WORKSTN
     F                                     SFILE(SD000730S0:DDSFRN)
 
      ** Transaction file - by Front Office Id.
     FSDFATCL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD FATCA Temporary Table
     FSDFCLSL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
      ** Midas SD FATCA Temporary Table
     FSDFCLSL2  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFCLSD0:SDFCLSD2)
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
 
     D P@Rtcd          S              7A
     D P@Optn          S              7A
     D P@CLAS          S              5A
     D P@FMT         E DS                  EXTNAME(SDFATCPD)
 
     D WMsgLen         S             15P 5 INZ(50)
 
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
     D PUpdat2         S              1A   INZ('N')                                        MD027355A
 
     DWCurrInput       DS
     D  D0FCCD
     D  D0NCD1
     D  D0NCD2
     D  D0CSTY
     D  D0RPTY
 
     DWPrevInput       DS
     D  PRFCCD                             LIKE(D0FCCD)
     D  PRNCD1                             LIKE(D0NCD1)
     D  PRNCD2                             LIKE(D0NCD2)
     D  PRCSTY                             LIKE(D0CSTY)
     D  PRRPTY                             LIKE(D0RPTY)
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
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
      ********************************************************************
      * SrPrcSFL - Process Subfile Actions
      ********************************************************************
     C     SrPrcSFL      BEGSR
 
     C                   OPEN      SDFCLSL0
     C                   OPEN      SDFCLSL2
     C                   DOW       NOT *INKC
 
     C                   EXSR      SrInitSFL
     C                   EXSR      SrBldSFL
 
     C                   EVAL      DDSFRN = 1                                               MD027258
     C                   WRITE     SD000730C1
     C                   WRITE     SD000730F1
     C                   EXFMT     SD000730C0
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
 
     C                   SELECT
 
     C                   WHEN      *INKI = *ON
     C                   EVAL      WACTN = 'I'
     C                   EXSR      SrProcACTN
 
     C                   IF        WError <> 'Y'
     C                             AND WWrite <> 'N'
     C                   EVAL      DPFCCD = D0FCCD
     C                   EVAL      DPFCTP = D0CSTY
     C                   EVAL      DPFCD1 = D0NCD1
     C                   EVAL      DPFCD2 = D0NCD2
     C                   EVAL      DPRTYP = D0RPTY
 
     C                   WRITE     SDFCLSD0
     C                   ENDIF
 
     C                   ITER
 
      ** Run Tool in Information Mode
     C                   WHEN      *INKK = *ON
 
     C                   CLOSE     SDFCLSL0
     C                   CLOSE     SDFCLSL2
     C**********         EVAL      PInfoRanF = 'Y'                                MD027360 MD027355A
     C                   CALL      'SDC000731'
     C                   PARM                    PInfoRanF
     C                   PARM                    PUpdatRanF
     C                   PARM      'N'           PUpdat2                                   MD027355A
 
     C                   EVAL      PInfoRanF = 'Y'
 
     C                   IF        *INU7 = *ON OR *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   OPEN      SDFCLSL0
     C                   OPEN      SDFCLSL2
 
     C                   CALL      'SDC000733'
     C                   PARM      'I'           PMode
 
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
 
     C                   CLOSE     SDFCLSL0
     C                   CLOSE     SDFCLSL2
     C**********         EVAL      PUpdatRanF = 'Y'                               MD027360 MD027355A
     C                   CALL      'SDC000731'
     C                   PARM                    PInfoRanF
     C                   PARM                    PUpdatRanF
     C                   PARM      'Y'           PUpdat2                                   MD027355A
 
     C                   EVAL      PUpdatRanF = 'Y'
 
     C                   IF        *INU7 = *ON OR *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   OPEN      SDFCLSL0
     C                   OPEN      SDFCLSL2
 
     C                   CALL      'SDC000733'
     C                   PARM      ' '           PMode
 
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
      ** If Initial Press, Send out Confirmation
      ** Check first if files can be locked
     C                   MONITOR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    WMsgLen
 
     C                   ON-ERROR  00202
     C                   EVAL      PZMsgID = 'USS0320'
     C                   EXSR      SRZasnms
     C                   EVAL      WLockF = 'N'
     C                   ENDMON
 
     C                   MONITOR
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    WMsgLen
 
     C                   ON-ERROR  00202
     C                   EVAL      PZMsgID = 'USS0320'
     C                   EXSR      SRZasnms
     C                   EVAL      WLockF = 'N'
     C                   ENDMON
 
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
 
      ** DO IN NEED THIS? OR SHOULD THIS BE A DEFAULT
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
     C                   READC     SD000730S0
 
     C                   DOW       NOT %EOF
     C                   EVAL      WACTN = S1ACTN
      *                                                                                     MD026650
      ** Only allow 'A', 'D' and 'E' action code.                                           MD026650
      *                                                                                     MD026650
     C                   IF        WACTN = 'A' OR                                           MD026650
     C                             WACTN = 'D' OR                                           MD026650
     C                             WACTN = 'E'                                              MD026650
     C                   EXSR      SrProcACTN
     C                   ELSE                                                               MD026650
     C                   EVAL      WError = 'Y'                                             MD026650
     C                   EVAL      PZMsgID = 'USR9357'                                      MD026650
     C                   EXSR      SRZasnms                                                 MD026650
     C                   ENDIF                                                              MD026650
 
     C                   IF        WError <> 'Y'
     C                             AND WWrite <> 'N'
 
     C                   IF        WACTN = 'A'
     C                   EVAL      KClas = S1FCCD
     C                   EVAL      KCSTY = S1CSTY
     C     KClasType     CHAIN     SDFCLSL0
     C                   ENDIF
 
     C                   EVAL      DPFCCD = D0FCCD
     C                   EVAL      DPFCTP = D0CSTY
     C                   EVAL      DPFCD1 = D0NCD1
     C                   EVAL      DPFCD2 = D0NCD2
     C                   EVAL      DPRTYP = D0RPTY
 
     C                   IF        WACTN = 'A'
     C                   UPDATE    SDFCLSD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      S1ACTN = *BLANKS
     C                   UPDATE    SD000730S0
     C                   READC     SD000730S0
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDDO
     C                   CLOSE     SDFCLSL0
     C                   CLOSE     SDFCLSL2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * SrBldSFL - Build Initial Subfile
      ********************************************************************
     C     SrBldSFL      BEGSR
 
     C                   EVAL      WNoData = 'Y'
     C                   EVAL      *IN98 = *ON
 
     C     *LOVAL        SETLL     SDFCLSL0
     C                   READ      SDFCLSL0
 
     C                   DOW       NOT %EOF(SDFCLSL0)
 
     C                   EVAL      S1FCCD = DPFCCD
     C                   EVAL      S1CSTY = DPFCTP
     C                   EVAL      S1NCD1 = DPFCD1
     C                   EVAL      S1NCD2 = DPFCD2
     C                   EVAL      S1RTYP = DPRTYP
     C                   EVAL      DDSFRN = DDSFRN + 1
     C                   WRITE     SD000730S0
     C                   EVAL      WNoData = 'N'
     C                   EVAL      *IN98 = *OFF
     C                   READ      SDFCLSL0
 
     C                   ENDDO
                                                                                            MD025321
      ** At end of file set the subfile end = *on                                           MD025321
                                                                                            MD025321
     C                   EVAL      *IN96 = *ON                                              MD025321
     C                   WRITE     SD000730C0                                               MD025321
 
     C                   IF        DDSFRN = 0
     C                   EVAL      PZMsgID = 'ASM0001'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * SrProcACTN - Process actions taken on the subfile
      ********************************************************************
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
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      D0FCCD = *BLANKS
     C                   EVAL      D0NDD1 = *BLANKS
     C                   EVAL      D0NCD1 = *BLANKS
     C                   EVAL      D0NDD2 = *BLANKS
     C                   EVAL      D0NCD2 = *BLANKS
     C                   EVAL      D0CSTY = *BLANKS
     C                   EVAL      D0CSTD = *BLANKS
     C                   EVAL      D0RPTY = *BLANKS
     C                   EVAL      D0RPTD = *BLANKS
     C                   ENDIF
 
 
     C                   IF        WACTN = 'I'
     C                             OR WACTN = 'A'
      ** Turn off Protect indicators
     C                   EVAL      *IN58 = *OFF
     C                   EVAL      *IN57 = *OFF
     C                   IF        WACTN = 'A'
     C                   EVAL      *IN57 = *ON
     C                   ENDIF
     C                   ELSE
     C                   EVAL      *IN57 = *ON
     C                   EVAL      *IN58 = *ON
     C                   ENDIF
 
     C                   IF        WACTN = 'D'
      ** Turn on  F10 to delete
     C                   EVAL      *IN59 = *ON
     C                   EVAL      WDelete = 'Y'
     C                   EVAL      PZMsgID = 'ASM0028'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   DOW       NOT *INKC
     C                             AND NOT *INKL
 
      ** Save Previous Input to check for changes
     C                   EVAL      WPrevInput = WCurrInput
 
     C                   WRITE     SD000730F2
     C                   WRITE     SD000730C1
     C                   EXFMT     SD000730D0
 
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
     C                   DELETE    SDFCLSL0
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
      ********************************************************************
      * SrValDet - Validate Details
      ********************************************************************
     C     SrValDet      BEGSR
      *
      ** Initialize to blanks
      *
     C                   EVAL      *IN60 = *OFF
     C                   EVAL      *IN62 = *OFF
     C                   EVAL      *IN63 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      *IN65 = *OFF
     C                   EVAL      D0NDD1 = *BLANKS
     C                   EVAL      D0NDD2 = *BLANKS
     C                   CALL      'ZA0250'
 
      ** Validate Current Classification Code
 
     C                   CALL      'AOFATCR0'
     C                   PARM                    P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      D0FCCD        P@CLAS
     C                   PARM                    P@FMT
 
      *
      ** For Amend, read files to determine number of current records.
      *
     C                   EVAL      WCtr = 0
     C                   IF        WActn = 'A'
      *
     C                   READ      SDFCLSL0
     C     DPFCCD        SETLL     SDFCLSL0
     C                   DOW       NOT %EOF (SDFCLSL0)
     C     D0FCCD        READE     SDFCLSL0
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
      *
     C                   ENDIF
     C                   IF        P@Rtcd <> *BLANKS AND
     C                             D0FCCD <> '*ALL'
     C                   EVAL      *IN60 = *ON
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0456'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   IF        D0FCCD =  '*ALL'
     C                   EVAL      D0FCDD = *BLANKS
      *
      ** Read through SDFCLSL0
      *
     C**********         READ      SDFCLSL0                                                 MD026650
     C*****DPFCCD        SETLL     SDFCLSL0                                                 MD026650
     C**********         DOW       NOT %EOF (SDFCLSL0)                                      MD026650
     C**********         READ      SDFCLSL0                                                 MD026650
      *
     C**********         IF        %FOUND (SDFCLSL0)                                        MD026650
      *
      ** If Customer Type is same with existing customer type
      *
     C**********         IF        D0CSTY = DPFCTP                                          MD026650
     C**********                   AND WCtr > 1                                             MD026650
     C**********         EVAL      WError = 'Y'                                             MD026650
     C**********         ENDIF                                                              MD026650
      *
      ** Check if customer type is existing
      *
     C     D0CSTY        CHAIN     SDFCLSL2
     C                   IF        %FOUND(SDFCLSL2)
     C**********                   AND WCtr > 1                                             MD026650
     C                   EVAL      WError = 'Y'
     C                   ENDIF
      *
      ** If '*' is the customer type, input not allowed.
      *
     C                   IF        D0CSTY = '*'
     C**********                   AND WCtr > 1                                             MD026650
      *                                                                                     MD027172
      ** Before inserting *ALL and * check first if there is an existing record             MD027172
      *                                                                                     MD027172
     C                   READ      SDFCLSL0                                                 MD027172
     C                   IF        %FOUND (SDFCLSL0)                                        MD027172
      *                                                                                     MD027172
     C                   EVAL      WError = 'Y'
      *                                                                                     MD027172
     C                   ENDIF                                                              MD027172
                                                                                            MD027172
     C                   ENDIF
      *
     C                   IF        WError = 'Y'
     C                   EVAL      *IN60 = *ON
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      PZMsgID = 'USS0462'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C**********         ENDIF                                                              MD026650
      *
     C**********         ENDDO                                                              MD026650
      ** Check if *ALL is allowed
 
     C                   EVAL      KCLAS = D0FCCD
     C                   EVAL      KCSTY = *BLANKS
 
     C     KClas         SETGT     SDFCLSL0
     C     KClas         READE     SDFCLSL0
 
     C                   IF        NOT %EOF(SDFCLSL0)
     C**********         IF        WCtr > 1                                                 MD026650
     C                   EVAL      *IN60 = *ON
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0462'
     C                   EXSR      SRZasnms
     C**********         ENDIF                                                              MD026650
     C                   ENDIF
      ** Check if *ALL is NOT allowed
     C                   ELSE
     C                   EVAL      KCLAS = '*ALL  '
 
     C     KClas         CHAIN     SDFCLSL0
     C                   IF        %FOUND(SDFCLSL0)
     C**********                   AND WCtr > 1                                             MD026650
      *
     C     D0CSTY        CHAIN     SDFCLSL2
     C                   IF        %FOUND(SDFCLSL2)
     C                   EVAL      *IN60 = *ON
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0461'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *                                                                                     MD027172
     C                   EVAL      KCSTY = '*'                                              MD027172
     C     KClasType     CHAIN     SDFCLSL0                                                 MD027172
     C                   IF        %FOUND(SDFCLSL0)                                         MD027172
     C                   EVAL      *IN60 = *ON                                              MD027172
     C                   EVAL      D0FCDD = *BLANKS                                         MD027172
     C                   EVAL      WError = 'Y'                                             MD027172
     C                   EVAL      PZMsgID = 'USS0461'                                      MD027172
     C                   EXSR      SRZasnms                                                 MD027172
     C                   ENDIF                                                              MD027172
      *                                                                                     MD027172
     C                   ENDIF
      *
      ** Read through SDFCLSL0
      *
     C                   READ      SDFCLSL0
     C     D0FCCD        SETLL     SDFCLSL0
     C                   DOW       NOT %EOF (SDFCLSL0)
     C                   READ      SDFCLSL0
     C                   IF        %FOUND (SDFCLSL0)
      *
      ** Error on existing record same input
      *
     C                   IF        D0FCCD = DPFCCD AND D0CSTY = DPFCTP
     C                             OR D0FCCD = DPFCCD AND D0CSTY = '*'
     C                   EVAL      *IN60 = *ON
     C                   EVAL      *IN64 = *ON
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0460'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   IF        WACTN = 'A' AND D0FCCD = S1FCCD
     C                             AND D0CSTY = S1CSTY
     C                   EVAL      *IN60 = *OFF
     C                   EVAL      *IN64 = *OFF
     C                   EVAL      D0FCDD = *BLANKS
     C                   EVAL      WError = *BLANKS
     C                   EVAL      PZMsgID = *BLANKS
     C                   CALL      'ZA0250'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
 
     C                   ENDIF
 
     C                   IF        D0FCCD = *BLANKS
     C                   EVAL      D0FCDD = *BLANKS
     C                   ELSE
     C                   EVAL      D0FCDD = FCDESC
     C                   ENDIF
      *
     C                   IF        D0FCCD = '*ALL'
     C                   EVAL      D0FCDD = *BLANKS
     C                   ENDIF
 
     C                   IF        %TRIM(D0FCCD) = '?'
     C                   EVAL      D0FCCD = FCCODE
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Customer Type
 
     C                   SELECT
     C                   WHEN      D0CSTY = 'O'
     C                   EVAL      D0CSTD = 'Other'
     C                   WHEN      D0CSTY = 'F'
     C                   EVAL      D0CSTD = 'Foreign Financial Institution'
     C                   WHEN      D0CSTY = 'N'
     C                   EVAL      D0CSTD = 'Non-financial Entity'
     C                   WHEN      D0CSTY = 'P'
     C                   EVAL      D0CSTD = 'Physical Person'
     C                   WHEN      D0CSTY = 'J'
     C                   EVAL      D0CSTD = 'Joint Account'
     C                   WHEN      D0CSTY = '*'
     C                   EVAL      D0CSTD = 'ALL'
 
     C                   EVAL      KCSTY = D0CSTY
     C                   EVAL      KClas = *BLANKS
 
     C     KCSTY         SETGT     SDFCLSL2
     C     KCSTY         READE     SDFCLSL2
 
     C                   IF        NOT %EOF(SDFCLSL2)
     C                   EVAL      *IN64 = *ON
     C                   EVAL      D0CSTD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0463'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   OTHER
 
     C                   EVAL      *IN64 = *ON
     C                   EVAL      D0CSTD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0457'
     C                   EXSR      SRZasnms
 
     C                   ENDSL
 
      ** Check if *ALL is NOT allowed
     C                   EVAL      KCSTY = '*'
 
     C                   EVAL      KCLAS = D0FCCD
     C     KClasType2    CHAIN     SDFCLSL2
     C                   IF        %FOUND(SDFCLSL2) AND
     C                             WActn = 'I'
     C                   EVAL      *IN64 = *ON
     C                   EVAL      D0CSTD = *BLANKS
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'USS0464'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   EVAL      KClas = *BLANKS
 
      ** Validate Classification 1
 
     C                   CALL      'AOFATCR0'
     C                   PARM                    P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      D0NCD1        P@CLAS
     C                   PARM                    P@FMT
 
     C                   IF        P@Rtcd <> *BLANKS
     C                             AND D0NCD1 <> *BLANKS
     C                   EVAL      *IN62 = *ON
     C                   EVAL      D0NDD1 = *BLANKS
     C                   EVAL      WError = 'Y'
 
     C                   EVAL      PZMsgID = 'USS0458'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   IF        D0NCD1 <> *BLANKS
     C                   EVAL      D0NDD1 = FCDESC
     C                   ENDIF
 
     C                   IF        D0NCD1 = *BLANKS
     C                   EVAL      D0NDD1 = *BLANKS
     C                   ENDIF
 
     C                   IF        %TRIM(D0NCD1) = '?'
     C                   EVAL      D0NCD1 = FCCODE
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Classification 2
 
     C                   CALL      'AOFATCR0'
     C                   PARM                    P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      D0NCD2        P@CLAS
     C                   PARM                    P@FMT
 
     C                   IF        P@Rtcd <> *BLANKS
     C                             AND D0NCD2 <> *BLANKS
     C                   EVAL      *IN63 = *ON
     C                   EVAL      D0NDD2 = *BLANKS
     C                   EVAL      WError = 'Y'
 
     C                   EVAL      PZMsgID = 'USS0458'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   IF        D0NCD2 <> *BLANKS
     C                   EVAL      D0NDD2 = FCDESC
     C                   ENDIF
 
     C                   IF        D0NCD2 = *BLANKS
     C                   EVAL      D0NDD2 = *BLANKS
     C                   ENDIF
 
     C                   IF        %TRIM(D0NCD2) = '?'
     C                   EVAL      D0NCD2 = FCCODE
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Reporting Type
 
     C                   SELECT
     C                   WHEN      D0RPTY = 'R'
     C                   EVAL      D0RPTD = 'Recalcitrant'
     C                   WHEN      D0RPTY = 'C'
     C                   EVAL      D0RPTD = 'Consent Received'
     C                   WHEN      D0RPTY = 'P'
     C                   EVAL      D0RPTD = 'Pending'
     C                   WHEN      D0RPTY = 'N'
     C                   EVAL      D0RPTD = 'Not Relevant'
     C                   WHEN      D0RPTY = 'U'
     C                   EVAL      D0RPTY = 'U'
     C                   EVAL      D0RPTD = 'Unknown'
     C                   WHEN      D0RPTY = *BLANKS
     C                   EVAL      D0RPTD = *BLANKS
     C                   OTHER
 
      ** Error on Reporting Type
     C                   EVAL      *IN65 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      D0RPTD = *BLANKS
 
     C                   EVAL      PZMsgID = 'USS0459'
     C                   EXSR      SRZasnms
 
     C                   ENDSL
      *
      ** Will not leave subroutine if error is occuring
      *
     C                   IF        WError = 'Y'
     C                   EVAL      WLeave = 'N'
     C                   ELSE
     C                   EVAL      WLeave = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * SrLoadDtls - Load Details if not doing insert
      ********************************************************************
     C     SrLoadDtls    BEGSR
 
     C                   EVAL      KCLAS = S1FCCD
     C                   EVAL      KCSTY = S1CSTY
     C                   EVAL      D0NDD1 = *BLANKS
     C                   EVAL      D0NDD2 = *BLANKS
 
     C     KClasType     CHAIN     SDFCLSL0
 
     C                   IF        NOT %FOUND(SDFCLSL0)
 
      ** DB Error
 
     C                   ENDIF
 
     C                   EVAL      D0FCCD = DPFCCD
      ** Validate Current Classification Code
 
     C                   CALL      'AOFATCR0'
     C                   PARM                    P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      D0FCCD        P@CLAS
     C                   PARM                    P@FMT
 
     C                   IF        P@Rtcd <> *BLANKS
     C                             AND D0FCCD <> '*ALL'
      ** DB Error
 
     C                   ELSE
 
     C                   IF        D0FCCD =  '*ALL'
     C                   EVAL      D0FCDD = *BLANKS
     C                   ELSE
     C                   EVAL      D0FCDD = FCDESC
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   EVAL      D0NCD1 = DPFCD1
      ** Validate Current Classification Code
 
     C                   CALL      'AOFATCR0'
     C                   PARM                    P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      D0NCD1        P@CLAS
     C                   PARM                    P@FMT
 
     C                   IF        P@Rtcd <> *BLANKS
      ** DB Error
 
     C                   ELSE
 
     C                   IF        D0NCD1 <> *BLANKS
     C                   EVAL      D0NDD1 = FCDESC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      D0NCD2 = DPFCD2
      ** Validate Current Classification Code
 
     C                   CALL      'AOFATCR0'
     C                   PARM                    P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM      D0NCD2        P@CLAS
     C                   PARM                    P@FMT
 
     C                   IF        P@Rtcd <> *BLANKS
      ** DB Error
 
     C                   ELSE
 
     C                   IF        D0NCD2 <> *BLANKS
     C                   EVAL      D0NDD2 = FCDESC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      D0CSTY = DPFCTP
 
     C                   SELECT
     C                   WHEN      D0CSTY = 'O'
     C                   EVAL      D0CSTD = 'Other'
     C                   WHEN      D0CSTY = 'F'
     C                   EVAL      D0CSTD = 'Foreign Financial Institution'
     C                   WHEN      D0CSTY = 'N'
     C                   EVAL      D0CSTD = 'Non-financial Entity'
     C                   WHEN      D0CSTY = 'P'
     C                   EVAL      D0CSTD = 'Physical Person'
     C                   WHEN      D0CSTY = 'J'
     C                   EVAL      D0CSTD = 'Joint Account'
     C                   WHEN      D0CSTY = '*'
     C                   EVAL      D0CSTD = 'ALL'
     C                   ENDSL
 
     C                   EVAL      D0RPTY = DPRTYP
 
     C                   SELECT
     C                   WHEN      D0RPTY = 'R'
     C                   EVAL      D0RPTD = 'Recalcitrant'
     C                   WHEN      D0RPTY = 'C'
     C                   EVAL      D0RPTD = 'Consent Received'
     C                   WHEN      D0RPTY = 'P'
     C                   EVAL      D0RPTD = 'Pending'
     C                   WHEN      D0RPTY = 'N'
     C                   EVAL      D0RPTD = 'Not Relevant'
     C                   WHEN      D0RPTY = 'U'
     C                   EVAL      D0RPTD = 'Unknown'
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * SrUpload - Uploads the Subfile into SDFCLSPD
      ********************************************************************
     C     SrUpload      BEGSR
 
     C                   EVAL      WPos = 0
 
     C                   DOU       %EOF(SD000730DF)
     C                             OR WPos = 9999
 
     C                   EVAL      WPos = WPos + 1
     C     WPos          CHAIN     SD000730S0
 
     C                   IF        D0FCCD <> *BLANKS
     C                   EVAL      DPFCCD = D0FCCD
     C                   EVAL      DPFCTP = D0CSTY
     C                   EVAL      DPFCD1 = D0NCD1
     C                   EVAL      DPFCD2 = D0NCD2
     C                   WRITE     SDFCLSD0
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrInitSFL - INITIALIZATION
      *****************************************************************
     C     SrInitSFL     BEGSR
 
     C                   Z-ADD     0             DDSFRN
     C                   EVAL      *IN96 = *OFF                                             MD025321
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SD000730C0
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
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM      'SD000730'    PZMsgData
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
      *
      ** Initialize program name
     C                   MOVEL     'SD000730'    DBPGM
      *
      ** Move workstation ID to screen field.
     C                   EVAL      DDWID  = PsJobName
     C                   EVAL      DDPGMQ = PSProcName
     C                   EVAL      DDUSER = PsUser
      *
     C                   MOVE      '1'           *IN94
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
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
 
     C     KClasType     KLIST
     C                   KFLD                    KClas
     C                   KFLD                    KCSTY
 
     C     KClasType2    KLIST
     C                   KFLD                    KCSTY
     C                   KFLD                    KClas
 
     C                   ENDSR
      *****************************************************************
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2013
** ##OV1
ALCOBJ OBJ((SDFTCSPD *FILE *EXCL)) WAIT(10)
** ##OV2
ALCOBJ OBJ((SDFTNHPD *FILE *EXCL)) WAIT(10)
** ##OV3
DLCOBJ OBJ((SDFTCSPD *FILE *EXCL))
** ##OV4
DLCOBJ OBJ((SDFTNHPD *FILE *EXCL))
