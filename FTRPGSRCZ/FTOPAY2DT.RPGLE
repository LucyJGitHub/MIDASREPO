     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Ext Sett Instn defaults')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY1DT  - FT Outgoing Payments Extended Settlement        *
      *                  Instructions Default Module                  *
      *                                                               *
      *  Function: This Program Defaults Outgoing Payments fields     *
      *            from Extended Settlement Instructions file         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CFT045  *CREATE    Date 04Aug11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CFT045 - Outgoing Payments - Extended Settlement Instructions*
      *                                                               *
      *****************************************************************
      *
      ** Outgoing Payments Ext. Sett. Instn. File
      **  by Currency & Beneficiary Bank
      *
     FSDOPESL2  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Transaction (screen formats)
      *
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Perform defaulting of Outgoing Payment Extended Settlement Instructions
      *
     C                   If        (SACTION = 'I') Or (SACTION = 'A')
     C                   Exsr      DFTExSetIns
     C                   Endif
      *
      ** Return
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INIT - Initial Processing                                    *
      *****************************************************************
     C     DFTExSetIns   BEGSR
      *
     C                   EVAL      K#CCY  = SPCCY
     C                   EVAL      K#BNK  = SBNC1
      *
     C     K_SDOPESL1    CHAIN     SDOPESD0                           11
      *
     C                   IF        *IN11 = *OFF
     C                   EXSR      MOVExSetIns
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * MOVExSetIns                                                   *
      *****************************************************************
     C     MOVExSetIns   BEGSR
      *
      ** Settlement Types
      *
     C                   IF        SSTTP = *BLANKS
     C                   EVAL      SSTTP = ESPMTD
     C                   ENDIF
      *
      ** Branch Code
      *
     C                   IF        SBRCA = *BLANKS
     C                   EVAL      SBRCA = ESBRCA
     C                   ENDIF
      *
      ** Send MT202
      ** - default only if Send MT202 and Destination is blank
      *
     C                   IF        SSNMT = 'N' AND
     C                             SDST1 = *BLANKS AND
     C                             SDST2 = *BLANKS AND
     C                             SDST3 = *BLANKS AND
     C                             SDST4 = *BLANKS
     C                   EVAL      SSNMT = ESCMT
     C                   ENDIF
      *
      ** Destination 1
      ** Destination 2
      ** Destination 3
      ** Destination 4
      *
     C                   IF        SSNMT = 'Y'
      *
      ** If Send MT202 = Y then Destination is the Recipient of Payment Instructions
      *
     C                   IF        SDST1 = *BLANKS AND
     C                             SDST2 = *BLANKS AND
     C                             SDST3 = *BLANKS AND
     C                             SDST4 = *BLANKS
     C                   EVAL      SDST1 = ESPRI1
     C                   EVAL      SDST2 = ESPRI2
     C                   EVAL      SDST3 = ESPRI3
     C                   EVAL      SDST4 = ESPRI4
     C                   ENDIF
      *
     C                   ELSEIF    SSNMT = 'N'
      *
      ** If Send MT202 = Y then Destination is the Payment Nostro
      *
     C                   IF        SDST1 = *BLANKS AND
     C                             SDST2 = *BLANKS AND
     C                             SDST3 = *BLANKS AND
     C                             SDST4 = *BLANKS
     C                   EVAL      SDST1 = ESNSTR
     C                   ENDIF
     C*
     C                   ENDIF
      *
      ** Ordering Customer 1
      ** Ordering Customer 2
      ** Ordering Customer 3
      ** Ordering Customer 4
      ** Ordering Customer 5
      *
     C                   IF        SORC1 = *BLANKS AND
     C                             SORC2 = *BLANKS AND
     C                             SORC3 = *BLANKS AND
     C                             SORC4 = *BLANKS AND
     C                             SORC5 = *BLANKS
     C                   EVAL      SORC1 = ESPOC1
     C                   EVAL      SORC2 = ESPOC2
     C                   EVAL      SORC3 = ESPOC3
     C                   EVAL      SORC4 = ESPOC4
     C                   EVAL      SORC5 = ESPOC5
     C                   ENDIF
      *
      ** Ordering Bank
      *
     C                   IF        SORBK = *BLANKS
     C                   EVALR     SORBK = ESPOB
     C                   ENDIF
      *
      ** Receiver's Correspondent 1
      ** Receiver's Correspondent 2
      ** Receiver's Correspondent 3
      ** Receiver's Correspondent 4
      ** Receiver's Correspondent 5
      *
     C                   IF        SRCO1 = *BLANKS AND
     C                             SRCO2 = *BLANKS AND
     C                             SRCO3 = *BLANKS AND
     C                             SRCO4 = *BLANKS AND
     C                             SRCO5 = *BLANKS
     C                   EVAL      SRCO1 = ESRCR1
     C                   EVAL      SRCO2 = ESRCR2
     C                   EVAL      SRCO3 = ESRCR3
     C                   EVAL      SRCO4 = ESRCR4
     C                   EVAL      SRCO5 = ESRCR5
     C                   ENDIF
      *
      ** Intermediary Bank 1
      ** Intermediary Bank 2
      ** Intermediary Bank 3
      ** Intermediary Bank 4
      ** Intermediary Bank 5
      *
     C                   IF        SINB1 = *BLANKS AND
     C                             SINB2 = *BLANKS AND
     C                             SINB3 = *BLANKS AND
     C                             SINB4 = *BLANKS AND
     C                             SINB5 = *BLANKS
     C                   EVAL      SINB1 = ESPIB1
     C                   EVAL      SINB2 = ESPIB2
     C                   EVAL      SINB3 = ESPIB3
     C                   EVAL      SINB4 = ESPIB4
     C                   EVAL      SINB5 = ESPIB5
     C                   ENDIF
      *
      ** A/C with Bank 1
      ** A/C with Bank 2
      ** A/C with Bank 3
      ** A/C with Bank 4
      ** A/C with Bank 5
      *
     C                   IF        SACB1 = *BLANKS AND
     C                             SACB2 = *BLANKS AND
     C                             SACB3 = *BLANKS AND
     C                             SACB4 = *BLANKS AND
     C                             SACB5 = *BLANKS
     C                   EVAL      SACB1 = ESACB1
     C                   EVAL      SACB2 = ESACB2
     C                   EVAL      SACB3 = ESACB3
     C                   EVAL      SACB4 = ESACB4
     C                   EVAL      SACB5 = ESACB5
     C                   ENDIF
      *
      ** Third Reimbursement Institution 1
      ** Third Reimbursement Institution 2
      ** Third Reimbursement Institution 3
      ** Third Reimbursement Institution 4
      ** Third Reimbursement Institution 5
      *
     C                   IF        STRI1 = *BLANKS AND
     C                             STRI2 = *BLANKS AND
     C                             STRI3 = *BLANKS AND
     C                             STRI4 = *BLANKS AND
     C                             STRI5 = *BLANKS
     C                   EVAL      STRI1 = ESTRI1
     C                   EVAL      STRI2 = ESTRI2
     C                   EVAL      STRI3 = ESTRI3
     C                   EVAL      STRI4 = ESTRI4
     C                   EVAL      STRI5 = ESTRI5
     C                   ENDIF
      *
      ** Details Of Pay 1
      ** Details Of Pay 2
      ** Details Of Pay 3
      ** Details Of Pay 4
      *
     C                   IF        SDTP1 = *BLANKS AND
     C                             SDTP2 = *BLANKS AND
     C                             SDTP3 = *BLANKS AND
     C                             SDTP4 = *BLANKS
     C                   EVAL      SDTP1 = ESDPY1
     C                   EVAL      SDTP2 = ESDPY2
     C                   EVAL      SDTP3 = ESDPY3
     C                   EVAL      SDTP4 = ESDPY4
     C                   ENDIF
      *
      ** Details of Charges
      *
     C                   IF        SDTCH = *BLANKS
     C                   EVAL      SDTCH = ESDCHG
     C                   ENDIF
      *
      ** Bank - Bank Info 1
      ** Bank - Bank Info 2
      ** Bank - Bank Info 3
      ** Bank - Bank Info 4
      ** Bank - Bank Info 5
      ** Bank - Bank Info 6
      *
     C                   IF        SBBI1 = *BLANKS AND
     C                             SBBI2 = *BLANKS AND
     C                             SBBI3 = *BLANKS AND
     C                             SBBI4 = *BLANKS AND
     C                             SBBI5 = *BLANKS AND
     C                             SBBI6 = *BLANKS
     C                   EVAL      SBBI1 = ESBBI1
     C                   EVAL      SBBI2 = ESBBI2
     C                   EVAL      SBBI3 = ESBBI3
     C                   EVAL      SBBI4 = ESBBI4
     C                   EVAL      SBBI5 = ESBBI5
     C                   EVAL      SBBI6 = ESBBI6
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Transaction information (DS) in screen format from source system
      *
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInPrmB
     C                   PARM                    TranInThir
     C                   PARM                    TranInFour
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         In        LDA
     C                   Movel     'FTOPAY3DT'   DBPGM
     C                   Out       LDA
      *
      ** Key list for Outgoing Payments Settlement Instructions
      *
     C     K_SDOPESL1    KLIST
     C                   KFLD                    K#CCY             3
     C                   KFLD                    K#BNK            11
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      ********************************************************************
      /EJECT
