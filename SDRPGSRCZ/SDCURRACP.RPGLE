     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Currency Details Acceptance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCURRACP - SD Currency Details Acceptance                   *
      *                                                               *
      *  Function:  This program updates the Zonal file and the       *
      *             Acceptance file based on the data sent by the     *
      *             background jobs.                                  *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance Job        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG12685           Date 15Nov06               *
      *                 BUG12476           Date 07Nov06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG12685 - Trailer file PF/RECCYZ not updated properly.      *
      *  BUG12476 - GLC39 00001 failed                                *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SrZone - Entry routine to update Zonal files                 *
      *  Sr_UpdFaclty - Routine to update Facility File               *
      *  Sr_UpdTrailr - Routine to update Trailer File                *
      *  SrAccp - Entry routine to update Acceptance files            *
      *  SrQcmd - Routine to submit delay job via QCMDEXC             *
      *  SrChkAcod - Routine to check all account code fields         *                     BUG12476
      *  SrValAcod - Routine to validate account code fields          *                     BUG12476
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Standing Data Control file
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Currency Details file
     FSDCURRL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas SD Currency Details Acceptance file
     FSDACURL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Midas RE ICD By Currency
     FRECCY     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     IGNORE(RECCYAF)
     F                                     IGNORE(RECCYZF)
 
      ** Midas RE ICD Retail Extension file
     FRECCYDXC  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Midas RE Installation Control Trailer file
     FRECCYZ    UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Midas SD Narrative Codes Acceptance file DS
     D Ds_AcceptFile E DS                  ExtName(SDZCURRPD)
      *
      ** Midas SD Temprary Narrative Codes Acceptance file DS
     D Ds_AcceptTemp E DS                  ExtName(SDZCURRPD)
     D                                     Prefix(X:1)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Account Code Details                                               BUG12476
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                BUG12476
                                                                                            BUG12476
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DNATN         E DS                  EXTNAME(MNATN)
 
      *
      ** Data Structure for array totals in RECCYZ
     D DNR             DS            15
     D  NR                     1     15
     D  NR1                    1      3P 0
     D  NR2                    4      6P 0
     D  NR3                    7      9P 0
     D  NR4                   10     12P 0
     D  NR5                   13     15P 0
 
     D                 DS
     D AS400TMST                     26A
     D  POS11                 11     11A
     D  POS14                 14     14A
     D  POS17                 17     17A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Entry Parameters
 
     D PData           S           4000A
     D PRetCode        S              7A
     D PProgram        S             10A
 
     D p_Cmd           S             13A
     D p_CmdLen        S             15  5 Inz(%Len(p_Cmd))
 
     D w_CurCode       S                   Like(A6CYCD)
     D w_CurrICD       S                   Like(KEY)
     D w_ICDAction     S              1A
     D w_Action        S              1A
 
     D PZreturn        S              1
     D PZfield         S             16
     D PZdecimals      S              1P 0
     D PZdigits        S              2P 0
     D W6SPRT          S             20P 9
     D W6TKCC          S                   LIKE(A6TKCC)
     D W6ISON          S                   LIKE(A6ISON)
     D W6EFDT          S                   LIKE(A6EFDT)
     D WAcodCtr        S              2  0                                                  BUG12476
 
     D v_Count         S              3  0
 
     D i_Success       S               N
     D i_Process       S               N
 
     D c_Yes           C                   Const('Y')
     D c_Insert        C                   Const('I')
     D c_Amend         C                   Const('A')
     D c_File          C                   Const('SDCURRPD  ')
     D c_DelayJob      C                   Const('DLYJOB DLY(1)')
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
     C                   EVAL      Ds_AcceptFile = PData
     C                   EXSR      SrConvert
 
     C                   EVAL      w_CurCode = A6CYCD
 
     C                   IF        A6AACC = c_Yes or
     C                             PProgram = 'SDC000061'
     C                   EXSR      SrZone
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF
 
      ** Commit changes if there are no errors, otherwise rollback
 
     C                   IF        PRetCode = *Blanks
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrConvert - Moves Zoned Numeric to Packed Fields             *
      *                                                               *
      *****************************************************************
 
     C     SrConvert     BEGSR
 
      ** Convert character input to numeric
 
     C                   IF        Z6NBDP = *Blanks
     C                   EVAL      A6NBDP = *Zeros
     C                   ELSE
     C                   MOVE      Z6NBDP        A6NBDP
     C                   ENDIF
 
     C                   IF        Z6LCD  = *Blanks
     C                   EVAL      A6LCD  = *Zeros
     C                   ELSE
     C                   MOVE      Z6LCD         A6LCD
     C                   ENDIF
 
     C                   IF        Z6TXND = *Blanks
     C                   EVAL      A6TXND = *Zeros
     C                   ELSE
     C                   MOVE      Z6TXND        A6TXND
     C                   ENDIF
 
     C                   IF        Z6PRRT = *Blanks
     C                   EVAL      A6PRRT = *Zeros
     C                   ELSE
     C                   MOVE      Z6PRRT        A6PRRT
     C                   ENDIF
 
     C                   IF        Z6SRC1 = *Blanks
     C                   EVAL      A6SRC1 = *Zeros
     C                   ELSE
     C                   MOVE      Z6SRC1        A6SRC1
     C                   ENDIF
 
     C                   IF        Z6SRC2 = *Blanks
     C                   EVAL      A6SRC2 = *Zeros
     C                   ELSE
     C                   MOVE      Z6SRC2        A6SRC2
     C                   ENDIF
 
     C                   IF        Z6SSNB = *Blanks
     C                   EVAL      A6SSNB = *Zeros
     C                   ELSE
     C                   MOVE      Z6SSNB        A6SSNB
     C                   ENDIF
 
     C                   IF        Z6ERLC = *Blanks
     C                   EVAL      A6ERLC = *Zeros
     C                   ELSE
     C                   MOVE      Z6ERLC        A6ERLC
     C                   ENDIF
 
     C                   IF        Z6SPDY = *Blanks
     C                   EVAL      A6SPDY = *Zeros
     C                   ELSE
     C                   MOVE      Z6SPDY        A6SPDY
     C                   ENDIF
 
     C                   IF        Z6HSRT = *Blanks
     C                   EVAL      A6HSRT = *Zeros
     C                   ELSE
     C                   MOVE      Z6HSRT        A6HSRT
     C                   ENDIF
 
     C                   IF        Z6LSPR = *Blanks
     C                   EVAL      A6LSPR = *Zeros
     C                   ELSE
     C                   MOVE      Z6LSPR        A6LSPR
     C                   ENDIF
 
     C                   IF        Z6FXSD = *Blanks
     C                   EVAL      A6FXSD = *Zeros
     C                   ELSE
     C                   MOVE      Z6FXSD        A6FXSD
     C                   ENDIF
 
     C                   IF        Z6MMSD = *Blanks
     C                   EVAL      A6MMSD = *Zeros
     C                   ELSE
     C                   MOVE      Z6MMSD        A6MMSD
     C                   ENDIF
 
     C                   IF        Z6NQDP = *Blanks
     C                   EVAL      A6NQDP = *Zeros
     C                   ELSE
     C                   MOVE      Z6NQDP        A6NQDP
     C                   ENDIF
 
     C                   IF        Z6ENC1 = *Blanks
     C                   EVAL      A6ENC1 = *Zeros
     C                   ELSE
     C                   MOVE      Z6ENC1        A6ENC1
     C                   ENDIF
 
     C                   IF        Z6ENC2 = *Blanks
     C                   EVAL      A6ENC2 = *Zeros
     C                   ELSE
     C                   MOVE      Z6ENC2        A6ENC2
     C                   ENDIF
 
     C                   IF        Z6CNMC = *Blanks
     C                   EVAL      A6CNMC = *Zeros
     C                   ELSE
     C                   MOVE      Z6CNMC        A6CNMC
     C                   ENDIF
 
     C                   IF        Z6SLSR = *Blanks
     C                   EVAL      A6SLSR = *Zeros
     C                   ELSE
     C                   MOVE      Z6SLSR        A6SLSR
     C                   ENDIF
 
     C                   IF        Z6RMCM = *Blanks
     C                   EVAL      A6RMCM = *Zeros
     C                   ELSE
     C                   MOVE      Z6RMCM        A6RMCM
     C                   ENDIF
 
     C                   IF        Z6RKSQ = *Blanks
     C                   EVAL      A6RKSQ = *Zeros
     C                   ELSE
     C                   MOVE      Z6RKSQ        A6RKSQ
     C                   ENDIF
 
     C                   IF        Z6TKCC = *Blanks
     C                   EVAL      A6TKCC = *Zeros
     C                   ELSE
     C                   MOVE      Z6TKCC        A6TKCC
     C                   EVAL      W6TKCC = A6TKCC
     C                   ENDIF
 
     C                   IF        Z6CQCD = *Blanks
     C                   EVAL      A6CQCD = *Zeros
     C                   ELSE
     C                   MOVE      Z6CQCD        A6CQCD
     C                   ENDIF
 
     C                   IF        Z6SMLD = *Blanks
     C                   EVAL      A6SMLD = *Zeros
     C                   ELSE
     C                   MOVE      Z6SMLD        A6SMLD
     C                   ENDIF
 
     C                   IF        Z6ISON = *Blanks
     C                   EVAL      A6ISON = *Zeros
     C                   ELSE
     C                   MOVE      Z6ISON        A6ISON
     C                   EVAL      W6ISON = A6ISON
     C                   ENDIF
 
     C                   IF        Z6EUER = *Blanks
     C                   EVAL      A6EUER = *Zeros
     C                   ELSE
     C                   MOVE      Z6EUER        A6EUER
     C                   ENDIF
 
     C                   IF        Z6TPSD = *Blanks
     C                   EVAL      A6TPSD = *Zeros
     C                   ELSE
     C                   MOVE      Z6TPSD        A6TPSD
     C                   ENDIF
 
     C                   IF        Z6TPED = *Blanks
     C                   EVAL      A6TPED = *Zeros
     C                   ELSE
     C                   MOVE      Z6TPED        A6TPED
     C                   ENDIF
 
     C                   IF        Z6INER = *Blanks
     C                   EVAL      A6INER = *Zeros
     C                   ELSE
     C                   MOVE      Z6INER        A6INER
     C                   ENDIF
 
     C                   IF        Z6EXWC = *Blanks
     C                   EVAL      A6EXWC = *Zeros
     C                   ELSE
     C                   MOVE      Z6EXWC        A6EXWC
     C                   ENDIF
 
     C                   IF        Z6POWC = *Blanks
     C                   EVAL      A6POWC = *Zeros
     C                   ELSE
     C                   MOVE      Z6POWC        A6POWC
     C                   ENDIF
 
     C                   IF        Z6CYD1 = *Blanks
     C                   EVAL      A6CYD1 = *Zeros
     C                   ELSE
     C                   MOVE      Z6CYD1        A6CYD1
     C                   ENDIF
 
     C                   IF        Z6CYD2 = *Blanks
     C                   EVAL      A6CYD2 = *Zeros
     C                   ELSE
     C                   MOVE      Z6CYD2        A6CYD2
     C                   ENDIF
 
     C                   IF        Z6CYD3 = *Blanks
     C                   EVAL      A6CYD3 = *Zeros
     C                   ELSE
     C                   MOVE      Z6CYD3        A6CYD3
     C                   ENDIF
 
     C                   IF        Z6RENO = *Blanks
     C                   EVAL      A6RENO = *Zeros
     C                   ELSE
     C                   MOVE      Z6RENO        A6RENO
     C                   ENDIF
 
     C                   IF        Z6SWDP = *Blanks
     C                   EVAL      A6SWDP = *Zeros
     C                   ELSE
     C                   MOVE      Z6SWDP        A6SWDP
     C                   ENDIF
 
     C                   IF        Z6SWDT = *Blanks
     C                   EVAL      A6SWDT = *Zeros
     C                   ELSE
     C                   MOVE      Z6SWDT        A6SWDT
     C                   ENDIF
 
     C                   IF        Z6EFDT = *Blanks
     C                   EVAL      A6EFDT = *Zeros
     C                   ELSE
     C                   MOVE      Z6EFDT        A6EFDT
     C                   EVAL      W6EFDT = A6EFDT
     C                   ENDIF
 
     C                   IF        Z6DFTS = *Blanks
     C                   EVAL      A6DFTS = *Zeros
     C                   ELSE
     C                   MOVE      Z6DFTS        A6DFTS
     C                   ENDIF
 
     C                   IF        Z6SETD = *Blanks
     C                   EVAL      A6SETD = *Zeros
     C                   ELSE
     C                   MOVE      Z6SETD        A6SETD
     C                   ENDIF
 
     C                   IF        Z6IRDP = *Blanks
     C                   EVAL      A6IRDP = *Zeros
     C                   ELSE
     C                   MOVE      Z6IRDP        A6IRDP
     C                   ENDIF
 
     C                   IF        Z6FXDY = *Blanks
     C                   EVAL      A6FXDY = *Zeros
     C                   ELSE
     C                   MOVE      Z6FXDY        A6FXDY
     C                   ENDIF
 
     C                   IF        Z6EACC = *Blanks
     C                   EVAL      A6EACC = *Zeros
     C                   ELSE
     C                   MOVE      Z6EACC        A6EACC
     C                   ENDIF
 
     C                   IF        Z6SCEX = *Blanks
     C                   EVAL      A6SCEX = *Zeros
     C                   ELSE
     C                   MOVE      Z6SCEX        A6SCEX
     C                   ENDIF
 
     C                   IF        Z6HBRT = *Blanks
     C                   EVAL      A6HBRT = *Zeros
     C                   ELSE
     C                   MOVE      Z6HBRT        A6HBRT
     C                   ENDIF
 
     C                   IF        Z6DPBF = *Blanks
     C                   EVAL      A6DPBF = *Zeros
     C                   ELSE
     C                   MOVE      Z6DPBF        A6DPBF
     C                   ENDIF
 
     C                   IF        Z6BYSR = *Blanks
     C                   EVAL      A6BYSR = *Zeros
     C                   ELSE
     C                   MOVE      Z6BYSR        A6BYSR
     C                   ENDIF
 
     C                   IF        ZZSPRT = *Blanks
     C                   EVAL      A6SPRT = *Zeros
     C                   ELSE
     C                   MOVE      ZZSPRT        W6SPRT
     C                   EVAL      A6SPRT = W6SPRT
     C                   ENDIF
 
     C                   MOVEL     ZZDESC        A6CYNM
 
     C                   MOVEL     ZZSRTM        AS400TMST
     C                   EVAL      POS11 = '-'
     C                   EVAL      POS14 = '.'
     C                   EVAL      POS17 = '.'
     C                   MOVEL     AS400TMST     A6SRTM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAlign - Align Numeric Data                                 *
      *                                                               *
      *****************************************************************
 
     C     SrAlign       BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZreturn
     C                   PARM                    PZfield
     C                   PARM                    PZdecimals
     C                   PARM                    PZdigits
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZone - Zonal File Update Routine                           *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: Sr_UpdCurCod / Sr_UpdTrailr / Sr_UpdICFile /          *
      *         Sr_UpdICEFil / Sr_UpdICTFil                           *
      *                                                               *
      *****************************************************************
 
     C     SrZone        BEGSR
 
      ** Check all account code fields                                                      BUG12476
     C                   EXSR      SrChkAcod                                                BUG12476
     C                   IF        WAcodCtr > 0                                             BUG12476
     C                   EVAL      A6AACC = 'N'                                             BUG12476
     C                   EXSR      SrAccp                                                   BUG12476
     C                   GOTO      ZoneExit                                                 BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
      ** Update Narrative Code
 
     C                   EXSR      Sr_UpdCurCod
 
      ** Update Trailer file
 
     C                   EXSR      Sr_UpdTrailr
 
      ** Background Update CCY - Currency Codes
 
     C                   MOVEL     *BLANK        W0RTN             7
 
     C                   CALL      'SD0021U'                            90
     C     W0RTN         PARM      *BLANK        WQ0210            7
     C                   PARM      A6CYCD        WQ0211            3
     C                   PARM      A6SPAE        WQ0212           10
     C                   PARM      A6FTAE        WQ0213           10
     C                   PARM      A6SWAE        WQ0214           10
     C                   PARM      A6TAC4        WQ0215           10
     C                   PARM      A6TAC5        WQ0216           10
     C                   PARM      A6CDFN        WQ0217            2
     C                   PARM      A6ECDN        WQ0218            2
     C                   PARM      A6LCD         WQ0219            5 0
     C                   PARM      A6TYLC        WQ0220            1
     C                   PARM      A6CYNM        WQ0221           14
     C                   PARM      A6SPRT        WQ0222           13 8
     C                   PARM      A6SWCY        WQ0223            3
     C                   PARM      A6NBDP        WQ0224            1 0
     C                   PARM      A6TXND        WQ0225            1 0
     C                   PARM      A6PRRT        WQ0226           13 8
     C                   PARM      A6SRC1        WQ0227            4 0
     C                   PARM      A6SRC2        WQ0228            4 0
     C                   PARM      A6DLCI        WQ0229            1
     C                   PARM      A6SSNB        WQ0230            2 0
     C                   PARM      A6ERLC        WQ0231           13 8
     C                   PARM      A6MDIN        WQ0232            1
     C                   PARM      A6MDPR        WQ0233            1
     C                   PARM      A6MDHB        WQ0234            1
     C                   PARM      A6MDEX        WQ0235            1
     C                   PARM      A6NOSN        WQ0236           10
     C                   PARM      A6SPDY        WQ0237            3 0
     C                   PARM      A6FXSD        WQ0238            8 0
     C                   PARM      A6MMSD        WQ0239            8 0
     C                   PARM      A6NQDP        WQ0240            1 0
     C                   PARM      A6DICB        WQ0241            1
     C                   PARM      A6SCEX        WQ0242            1 0
     C                   PARM      A6EBDA        WQ0243           29
     C                   PARM      A6HBRT        WQ0244           13 8
     C                   PARM      A6ENC1        WQ0245            2 0
     C                   PARM      A6ENC2        WQ0246            2 0
     C                   PARM      A6CACD        WQ0247            3
     C                   PARM      A6CNMC        WQ0248            2 0
     C                   PARM      A6FRIH        WQ0249            1
     C                   PARM      A6SATH        WQ0250            1
     C                   PARM      A6SUNH        WQ0251            1
     C                   PARM      A6DPBF        WQ0252            1 0
     C                   PARM      A6BYSR        WQ0253           13 8
     C                   PARM      A6BYSS        WQ0254            1
     C                   PARM      A6SLSR        WQ0255           13 8
     C                   PARM      A6SLSS        WQ0256            1
 
      ** Call to program ended in error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   EXSR      *PSSR
     C                   END
 
      ** Update Installation Control file
 
     C                   EXSR      Sr_UpdICFile
 
      ** ...only process RE ICD Extension and Trailer File if;
      **    - Installation Control file record is not found
      **    - Installation Control file record is found and RECI = '*'
 
     C                   IF        i_Process
     C                   EXSR      Sr_UpdICEFil
     C                   EXSR      Sr_UpdICTFil
     C                   ENDIF
 
     C**********         ENDSR                                                         BUG12476
     C     ZoneExit      ENDSR                                                         BUG12476
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdCurCod - Currency Codes Update Routine                 *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdCurCod  BEGSR
 
     C                   EVAL      i_Success = *Off
 
      ** Update Currency Code with data from Acceptance File
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C     w_CurCode     CHAIN(e)  @A6REA4
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   IF        %Found(SDCURRL0)
 
      ** ...save PData to temporary DS to retrieve the required
      **    fields for update then manually move the values of
      **    the amendable fields
 
     C                   EVAL      Ds_AcceptTemp = PData
 
     C                   MOVEL     XZDESC        A6CYNM
     C                   EVAL      A6SWCY = X6SWCY
     C                   EVAL      A6CDFN = X6CDFN
     C                   EVAL      A6ECDN = X6ECDN
     C                   EVAL      A6NOSN = X6NOSN
     C                   EVAL      A6SPAE = X6SPAE
     C                   EVAL      A6FTAE = X6FTAE
     C                   EVAL      A6TAC4 = X6TAC4
     C                   EVAL      A6SWAE = X6SWAE
     C                   EVAL      A6TAC5 = X6TAC5
 
     C                   EVAL      A6TKCC = W6TKCC
 
     C                   EVAL      A6CSCD = X6CSCD
 
     C                   EVAL      A6ISON = W6ISON
 
     C                   EVAL      A6DLOC = X6DLOC
     C                   EVAL      A6AACC = X6AACC
     C                   EVAL      A6GPDT = X6GPDT
 
     C                   EVAL      A6EFDT = W6EFDT
 
     C                   EVAL      A6AACC = X6AACC
     C                   EVAL      A6TYLC = c_Amend
     C                   EVAL      A6EACC = BJRDNB
     C                   EVAL      A6LCD  = BJRDNB
 
     C                   UPDATE(e) @A6REA4
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_Action = c_Amend
 
     C                   ELSE
 
     C                   EVAL      A6TYLC = c_Insert
     C                   EVAL      A6EACC = BJRDNB
     C                   EVAL      A6LCD  = BJRDNB
 
     C                   WRITE(e)  @A6REA4
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_Action = c_Insert
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCURRL0'
     C                   EVAL      DBKEY  =  w_CurCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdCurCod'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdTrailr - Trailer File Update Routine                   *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdTrailr  BEGSR
 
     C                   EVAL      i_Success = *Off
 
      ** Update Trailer File
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...check if file is existing in trailer file
 
     C     c_File        CHAIN(e)  @AHREAU
     C                   IF        Not %Found(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  c_File
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdTrailr'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSEIF    %Error
     C                   ITER
     C                   ENDIF
 
      ** ...update necessary fields based on action performed in
      **    facility update routine
 
     C                   IF        w_Action = c_Insert
     C                   EVAL      AHNORC = AHNORC + 1
     C                   EVAL      AHNOIN = AHNOIN + 1
     C                   ELSE
     C                   EVAL      AHNOAM = AHNOAM + 1
     C                   ENDIF
     C                   UPDATE(e) @AHREAU
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors were
      **    encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDFCTLL0'
     C                   EVAL      DBKEY  =  c_File
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdTrailr'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdICFile - Installation Control File Update Routine      *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: Sr_FillRECCY                                          *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdICFile  BEGSR
 
     C                   EVAL      i_Success = *Off
 
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C                   EVAL      w_CurrICD = *Blanks
     C                   EVAL      %Subst(w_CurrICD:9:3) = w_CurCode
     C                   EVAL      %Subst(w_CurrICD:12)  = 'D'
 
     C     w_CurrICD     CHAIN(e)  RECCYDF
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
      ** ...if record is found and RECI is '*', update RECCY record
 
     C                   EVAL      i_Process = *On
     C                   IF        %Found(RECCY) and RECI = '*'
     C                   EXSR      Sr_FillRECCY
     C                   UPDATE(e) RECCYDF
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   EVAL      w_ICDAction = c_Amend
 
      ** ...if record is not found, write new RECCY record
 
     C                   ELSEIF    not %Found(RECCY)
     C                   EXSR      Sr_FillRECCY
     C                   WRITE(e)  RECCYDF
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C**********         EVAL      w_ICDAction = c_Amend                                    BUG12685
     C                   EVAL      w_ICDAction = c_Insert                                   BUG12685
 
      ** ...otherwise, do not process ICD Extension and Trailer Files
 
     C                   ELSE
     C                   EVAL      i_Process = *Off
 
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'RECCY   '
     C                   EVAL      DBKEY  =  w_CurrICD
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  004
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdICFile'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdICEFil - Installation Control Extension Update Routine *
      *                                                               *
      *  Called by: SrZone                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdICEFil  BEGSR
 
     C                   EVAL      i_Success = *Off
 
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C     w_CurCode     CHAIN(e)  RECCYDD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      RYCCYD = w_CurCode
     C                   EVAL      RYCHGC = *Zeros
     C                   EVAL      RYCHGD = *Zeros
     C                   EVAL      RYCHGW = *Zeros
     C                   EVAL      RYCHGF = *Zeros
     C                   EVAL      RYCHGS = *Zeros
     C                   EVAL      RYCHGM = *Zeros
     C                   EVAL      RYCHGT = *Zeros
     C                   EVAL      RYCHGB = *Zeros
     C                   EVAL      RYCHGL = *Zeros
     C                   EVAL      RYCHGA = *Zeros
     C                   EVAL      RYCHGQ = *Zeros
     C                   EVAL      RYCHGX = *Zeros
     C                   EVAL      RYCHGY = *Zeros
     C                   EVAL      RYACCH = *Zeros
     C                   EVAL      RYNBDP = A6NBDP
     C                   IF        %Found(RECCYDXC)
     C                   UPDATE(e) RECCYDD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
 
     C                   ELSE
 
     C                   WRITE(e)  RECCYDD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'RECCYDXC'
     C                   EVAL      DBKEY  =  w_CurCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  005
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/Sr_UpdICEFil'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_UpdICTFil - Installation Control Trailer Update Routine   *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     Sr_UpdICTFil  BEGSR
 
     C                   EVAL      i_Success = *Off
 
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C                   READ(e)   RECCYZF
     C                   IF        %Error
     C                   ITER
 
     C                   ELSEIF    not %Eof
     C                   EVAL      TNLU = NATN
     C                   IF        w_ICDAction = c_Insert
     C                   EVAL      NR1 = NR1 + 1
     C                   EVAL      NR3 = NR3 + 1                                            BUG12685
     C**********         EVAL      NR3 = NR1 + 1                                            BUG12685
     C                   ENDIF
     C                   IF        w_ICDAction = c_Amend                                    BUG12685
     C                   EVAL      NR4 = NR4 + 1                                            BUG12685
     C                   ENDIF                                                              BUG12685
     C                   UPDATE(e) RECCYZF
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ELSE
     C
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'RECCYZ'
     C                   EVAL      DBKEY  =  *Blanks
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAccp'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccp - Acceptane File Update Routine                       *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls: SrQcmd                                                *
      *                                                               *
      *****************************************************************
 
     C     SrAccp        BEGSR
 
      ** Update Acceptance File
      ** ...retry file processing until successful or until loop
      **    count is 100
 
     C                   DO        100           v_Count
 
      ** ...only process delay when error is encountered, that is
      **    when loop is iterated
 
     C                   IF        v_Count > 1
     C                   EXSR      SrQcmd
     C                   ENDIF
 
      ** ...if there are errors, iterate and start anew with processing
      **    until updates are successful
 
     C     w_CurCode     CHAIN(e)  SDCURRD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   IF        %Found(SDACURL0)
     C                   EVAL      Ds_AcceptFile = PData
     C                   EXSR      SrConvert
     C                   UPDATE(e) SDCURRD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ELSE
     C                   WRITE(e)  SDCURRD0
     C                   IF        %Error
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** ...if the program reaches this point, no errors
      **    were encountered
 
     C                   EVAL      i_Success = *On
     C                   LEAVE
 
     C                   ENDDO
 
     C                   IF        i_Success = *Off
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDACURPD'
     C                   EVAL      DBKEY  =  w_CurCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  007
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAccp'
     C                   OUT       LDA
     C                   EVAL      PRetCode = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrQcmd - Job Command Execution routine                       *
      *                                                               *
      *  Called by: Sr_UpdLoanF / Sr_UpdTrailr / SrAccp               *
      *                                                               *
      *  Calls: QCMDEXC                                               *
      *                                                               *
      *****************************************************************
 
     C     SrQcmd        BEGSR
 
     C                   CALL      'QCMDEXC'
     C                   PARM      c_DelayJob    p_Cmd
     C                   PARM                    p_CmdLen
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Sr_FillRECCY - Populate RECCY Record Routine                 *
      *                                                               *
      *  Called by: Sr_UpdICFile                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     Sr_FillRECCY  BEGSR
 
     C                   EVAL      RECI  = 'D'
     C                   EVAL      KEY   = w_CurrICD
     C                   EVAL      ZZ017 = *Blanks
     C                   EVAL      ORED  = A6LCD
     C                   EVAL      LCD   = A6LCD
     C                   EVAL      CHTP  = 'I'
     C                   EVAL      HASH  = *Zeros
     C                   EVAL      MIDC  = *Zeros
     C                   EVAL      MADC  = 9999999999999
     C                   EVAL      MICC  = *Zeros
     C                   EVAL      MACC  = 9999999999999
     C                   EVAL      ZZ053 = *Blanks
     C                   EVAL      HORT  = *Zeros
     C                   EVAL      HOMN  = *Zeros
     C                   EVAL      HOMX  = 9999999999999
     C                   EVAL      ACRT  = *Zeros
     C                   EVAL      ACMN  = *Zeros
     C                   EVAL      ACMX  = 9999999999999
     C                   EVAL      DIRT  = *Zeros
     C                   EVAL      DIMN  = *Zeros
     C                   EVAL      DIMX  = 9999999999999
     C                   EVAL      INFC  = *Zeros
     C                   EVAL      MCFC  = *Zeros
     C                   EVAL      AMBC  = *Zeros
     C                   EVAL      MSFC  = *Zeros
     C                   EVAL      AMBS  = *Zeros
     C                   EVAL      DSFC  = *Zeros
     C                   EVAL      DSMN  = *Zeros
     C                   EVAL      DSMX  = *Zeros
     C                   EVAL      FCFC  = *Zeros
     C                   EVAL      AMO1  = *Zeros
     C                   EVAL      AMO2  = *Zeros
     C                   EVAL      AMO3  = *Zeros
     C                   EVAL      AMO4  = *Zeros
     C                   EVAL      AMO5  = *Zeros
     C                   EVAL      AMO6  = *Zeros
     C                   EVAL      AMO7  = *Zeros
     C                   EVAL      AMO8  = *Zeros
     C                   EVAL      CMNR  = *Zeros
     C                   EVAL      CMNP  = *Zeros
     C                   EVAL      CMNV  = *Zeros
     C                   EVAL      CADR  = *Zeros
     C                   EVAL      CADP  = *Zeros
     C                   EVAL      CADV  = *Zeros
     C                   EVAL      ZZ175 = *Blanks
 
      ** ...retrieve and update Transaction # of last update
 
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
     C                   EVAL      NATN = NATN + 1
     C                   OUT       DNATN
     C                   EVAL      TNLU = NATN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG12476
      *                                                               *                     BUG12476
      *  SrChkAcod - Check all Account Code fields                    *                     BUG12476
      *                                                               *                     BUG12476
      *  Called by: SrZone                                            *                     BUG12476
      *                                                               *                     BUG12476
      *  Calls: SrValAcod                                             *                     BUG12476
      *                                                               *                     BUG12476
      *****************************************************************                     BUG12476
                                                                                            BUG12476
     C     SrChkAcod     BEGSR                                                              BUG12476
                                                                                            BUG12476
     C                   EVAL      WAcodCtr = 0                                             BUG12476
                                                                                            BUG12476
     C                   IF        A6SPAE <> *BLANKS                                        BUG12476
     C                   EVAL      WAcod = A6SPAE                                           BUG12476
     C                   EXSR      SrValAcod                                                BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   IF        A6FTAE <> *BLANKS                                        BUG12476
     C                   EVAL      WAcod = A6FTAE                                           BUG12476
     C                   EXSR      SrValAcod                                                BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   IF        A6SWAE <> *BLANKS                                        BUG12476
     C                   EVAL      WAcod = A6SWAE                                           BUG12476
     C                   EXSR      SrValAcod                                                BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   IF        A6TAC4 <> *BLANKS                                        BUG12476
     C                   EVAL      WAcod = A6TAC4                                           BUG12476
     C                   EXSR      SrValAcod                                                BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   IF        A6TAC5 <> *BLANKS                                        BUG12476
     C                   EVAL      WAcod = A6TAC5                                           BUG12476
     C                   EXSR      SrValAcod                                                BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   IF        A6CSCD <> *BLANKS                                        BUG12476
     C                   EVAL      WAcod = A6CSCD                                           BUG12476
     C                   EXSR      SrValAcod                                                BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   ENDSR                                                              BUG12476
      *****************************************************************                     BUG12476
      /EJECT                                                                                BUG12476
      *****************************************************************                     BUG12476
      *                                                               *                     BUG12476
      *  SrValAcod - Validate Account Code field                      *                     BUG12476
      *                                                               *                     BUG12476
      *  Called by: SrChkAcod                                         *                     BUG12476
      *                                                               *                     BUG12476
      *  Calls: None                                                  *                     BUG12476
      *                                                               *                     BUG12476
      *****************************************************************                     BUG12476
                                                                                            BUG12476
     C     SrValAcod     BEGSR                                                              BUG12476
                                                                                            BUG12476
     C                   CALL      'AOACODR0'                                               BUG12476
     C                   PARM      '*MSG   '     W0Rtn                                      BUG12476
     C                   PARM      '*KEY   '     W0Optn            7                        BUG12476
     C                   PARM                    WAcod            10                        BUG12476
     C     SDACOD        PARM      SDACOD        DSFDY                                      BUG12476
                                                                                            BUG12476
     C                   IF        W0RTN <> *BLANKS                                         BUG12476
     C                   EVAL      WAcodCtr = WAcodCtr + 1                                  BUG12476
     C                   ENDIF                                                              BUG12476
                                                                                            BUG12476
     C                   ENDSR                                                              BUG12476
      *****************************************************************                     BUG12476
      /EJECT                                                                                BUG12476
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PData
     C                   PARM                    PRetCode
     C                   PARM                    PProgram
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Datebase error
 
     C     @RTCD         IFNE      *BLANKS
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR '
     C                   EXSR      *PSSR
     C                   OUT       LDA
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: Sr_UpdCurCod / Sr_UpdTrailr / Sr_UpdICFile /      *
      *             Sr_UpdICEFil / Sr_UpdICTFil / SrAccp              *
      *  Calls: DBERRCTL                                              *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   ROLBK
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
