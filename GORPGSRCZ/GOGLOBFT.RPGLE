     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - FT')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBFT - Global Updates - FT                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CAP212             Date 15Sep14               *
      *                 CGP017             Date 06Aug12               *
      *                 CER049             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG433             Date 02Dec05               *
      *                 CSF003             Date 03Nov04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP212 - FT Nostro Transfer API                              *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  CER049 - Stamp Tax                                           *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  BUG433 - Global files for FTPDOCPD, FTXTRHPD and FTPCHGPD    *
      *  CSF003 - User Defined Forms                                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
      ** Switchable Feature Details Data Structure                                            CSF003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSF003
                                                                                              CSF003
      ** Short Access Object Data Structure                                                   CSF003
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSF003
                                                                                              CSF003
      ** Access Object Parameters                                                             CSF003
     D PRtCd           S              7A                                                      CSF003
     D POptn           S              7A                                                      CSF003
     D PSARD           S              6A                                                      CSF003
                                                                                              CSF003
      ** FT Ext Table Delete Handler Parameters                                               CSF003
     D PPFName         S                         LIKE(PFLNAME)                                CSF003
     D PZone           S                         LIKE(I#ZONE)                                 CSF003
     D PBIMG           S                         LIKE(I#BIMG)                                 CSF003
                                                                                              CSF003
      ** Switchable Features                                                                  CSF003
     D CSF003          S              1A                                                      CSF003
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
      * Recover before and after image
 
     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000
 
     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000
 
 
      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF
 
     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP
 
      * Determine updates
 
     C                   EXSR      DET_UPDATES
 
     C                   MOVEL     'B'           I#BFAF
     C                   DO        2
 
     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C     PFLNAME       CASEQ     'FT101DPD'    GLOB_FT101DPD
     C     PFLNAME       CASEQ     'FT101HPD'    GLOB_FT101HPD
     C     PFLNAME       CASEQ     'FT102DPD'    GLOB_FT102DPD
     C     PFLNAME       CASEQ     'FT102HPD'    GLOB_FT102HPD
     C     PFLNAME       CASEQ     'INPAYDD'     GLOB_INPAYDD
     C     PFLNAME       CASEQ     'INPAYDQD'    GLOB_INPAYDQD                                CER049
     C     PFLNAME       CASEQ     'INPAYXPD'    GLOB_INPAYXPD
     C     PFLNAME       CASEQ     'OTPAYDD'     GLOB_OTPAYDD
     C     PFLNAME       CASEQ     'OTPAYDQD'    GLOB_OTPAYDQD                                CER049
     C     PFLNAME       CASEQ     'OTPAYXPD'    GLOB_OTPAYXPD
     C     PFLNAME       CASEQ     'FTXTRHPD'    GLOB_FTXTRHPD                                BUG433
     C     PFLNAME       CASEQ     'FTPDOCPD'    GLOB_FTPDOCPD                                BUG433
     C     PFLNAME       CASEQ     'FTPCHGPD'    GLOB_FTPCHGPD                                BUG433
     C     PFLNAME       CASEQ     'NTRANDD'     GLOB_NTRANDD                                 CAP212
     C                   ENDCS
                                                                                              CSF003
      ** Update the FT Extension Tables for deletes.                                          CSF003
                                                                                              CSF003
     C                   IF        CSF003 = 'Y' AND                                           CSF003
     C                             I#BFAF = 'B'                                               CSF003
     C                   IF        PFLNAME = 'FT101HPD' OR                                    CSF003
     C                             PFLNAME = 'FT102HPD'                                       CSF003
     C                   EXSR      SRUpdExtTbl                                                CSF003
     C                   ENDIF                                                                CSF003
     C                   ENDIF                                                                CSF003
                                                                                              CSF003
     C                   ENDIF
 
     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO
 
     C                   RETURN
 
      /SPACE 5
      *****************************************************************
      * Global Updates - Request For Transfer Detail
      *****************************************************************
     C     GLOB_FT101DPD BEGSR
      /COPY GPCPYSRCG,GPFT101DPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Request For Transfer Header
      *****************************************************************
     C     GLOB_FT101HPD BEGSR
      /COPY GPCPYSRCG,GPFT101HPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Customer Credit Transfer Detail
      *****************************************************************
     C     GLOB_FT102DPD BEGSR
      /COPY GPCPYSRCG,GPFT102DPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Customer Credit Transfer Header
      *****************************************************************
     C     GLOB_FT102HPD BEGSR
      /COPY GPCPYSRCG,GPFT102HPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Incoming Payments
      *****************************************************************
     C     GLOB_INPAYDD  BEGSR
      /COPY GPCPYSRCG,GPINPAYDD
     C                   ENDSR
      *****************************************************************                       CER049
      /SPACE 5                                                                                CER049
      *****************************************************************                       CER049
      * Global Updates - Incoming Payments Stamp Tax Extension                                CER049
      *****************************************************************                       CER049
     C     GLOB_INPAYDQD BEGSR                                                                CER049
      /COPY GPCPYSRCG,GPINPAYDQD                                                              CER049
     C                   ENDSR                                                                CER049
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Incoming Payments Extensions
      *****************************************************************
     C     GLOB_INPAYXPD BEGSR
      /COPY GPCPYSRCG,GPINPAYXPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Outgoing Payments
      *****************************************************************
     C     GLOB_OTPAYDD  BEGSR
      /COPY GPCPYSRCG,GPOTPAYDD
     C                   ENDSR
      *****************************************************************                       CER049
      /SPACE 5                                                                                CER049
      *****************************************************************                       CER049
      * Global Updates - Outgoing Payments Stamp Tax Extension                                CER049
      *****************************************************************                       CER049
     C     GLOB_OTPAYDQD BEGSR                                                                CER049
      /COPY GPCPYSRCG,GPOTPAYDQD                                                              CER049
     C                   ENDSR                                                                CER049
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Outgoing Payments Extensions
      *****************************************************************
     C     GLOB_OTPAYXPD BEGSR
      /COPY GPCPYSRCG,GPOTPAYXPD
     C                   ENDSR
      *****************************************************************                       BUG433
      * Global Updates - Exchange Rate Spread                                                 BUG433
      *****************************************************************                       BUG433
     C     GLOB_FTXTRHPD BEGSR                                                                BUG433
      /COPY GPCPYSRCG,GPFTXTRHPD                                                              BUG433
     C                   ENDSR                                                                BUG433
      *****************************************************************                       BUG433
      * Global Updates - Payment Date Offset Codes                                            BUG433
      *****************************************************************                       BUG433
     C     GLOB_FTPDOCPD BEGSR                                                                BUG433
      /COPY GPCPYSRCG,GPFTPDOCPD                                                              BUG433
     C                   ENDSR                                                                BUG433
      *****************************************************************                       BUG433
      * Global Updates - Payment Charge Definition                                            BUG433
      *****************************************************************                       BUG433
     C     GLOB_FTPCHGPD BEGSR                                                                BUG433
      /COPY GPCPYSRCG,GPFTPCHGPD                                                              BUG433
     C                   ENDSR                                                                BUG433
      *****************************************************************                       CAP212
      * Global Updates - Nostro Tranfers Table                                                CAP212
      *****************************************************************                       CAP212
     C     GLOB_NTRANDD  BEGSR                                                                CAP212
      /COPY GPCPYSRCG,GPNTRANDD                                                               CAP212
     C                   ENDSR                                                                CAP212
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Determine Updates
      *****************************************************************
     C     DET_UPDATES   BEGSR
 
     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1
 
     C                   ENDSR
      *****************************************************************                       CSF003
      /EJECT                                                                                  CSF003
      *****************************************************************                       CSF003
      *                                                               *                       CSF003
      *  SRUpdExtTbl - Updates the FT Extension Tables.               *                       CSF003
      *                                                               *                       CSF003
      *****************************************************************                       CSF003
     C     SRUpdExtTbl   BEGSR                                                                CSF003
                                                                                              CSF003
     C                   CALL      'FTC000010'                                                CSF003
     C                   PARM      *BLANKS       PRtCd                                        CSF003
     C                   PARM      PFLNAME       PPFName                                      CSF003
     C                   PARM      I#ZONE        PZone                                        CSF003
     C                   PARM      I#BIMG        PBIMG                                        CSF003
                                                                                              CSF003
     C                   IF        PRtCd <> *BLANKS                                           CSF003
     C     *LOCK         IN        LDA                                                        CSF003
     C                   EVAL      DBFile = PFLNAME                                           CSF003
     C                   EVAL      DBase = 102                                                CSF003
     C                   EVAL      DBKey = PZone                                              CSF003
     C                   OUT       LDA                                                        CSF003
     C                   EXSR      *PSSR                                                      CSF003
     C                   ENDIF                                                                CSF003
                                                                                              CSF003
     C                   ENDSR                                                                CSF003
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
                                                                                              CSF003
      ** Check if CSF003 is enabled.                                                          CSF003
                                                                                              CSF003
     C                   CALL      'AOSARDR0'                                                 CSF003
     C                   PARM      *BLANKS       PRtCd                                        CSF003
     C                   PARM      '*VERIFY'     POptn                                        CSF003
     C                   PARM      'CSF003'      PSARD                                        CSF003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSF003
                                                                                              CSF003
     C                   EVAL      CSF003 = 'N'                                               CSF003
                                                                                              CSF003
     C                   IF        PRtCd = *BLANKS                                            CSF003
     C                   EVAL      CSF003 = 'Y'                                               CSF003
     C                   ELSE                                                                 CSF003
                                                                                              CSF003
     C                   IF        PRtCd <> '*NRF   '                                         CSF003
     C     *LOCK         IN        LDA                                                        CSF003
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSF003
     C                   EVAL      DBKey = PSARD                                              CSF003
     C                   EVAL      DBase = 101                                                CSF003
     C                   OUT       LDA                                                        CSF003
     C                   EXSR      *PSSR                                                      CSF003
     C                   ENDIF                                                                CSF003
                                                                                              CSF003
     C                   ENDIF                                                                CSF003
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
