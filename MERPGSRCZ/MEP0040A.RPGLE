     H DEBUG
     F*****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MEP0040A - Check field for PCAT Information                  *
      *                                                               *
      *  Function:  This program places the customer in the field     *
      *  from a specified account                                     *
      *                                                               *
      *  (C) Copyrignt Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Jul2011             *
      *  Last Amend No. MK0519             Date 10Feb2005             *
      *  Prev Amend No. MK0504             Date 02Feb2005             *
      *                 MK0503             Date 01Feb2005             *
      *                 ESL038             Date 01Oct2004             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *  MK0519 - Change handling of data on return from bank's pgm.  *
      *  MK0504 - Add call to IBAN repair program.                    *
      *  MK0503 - If account not found by FT$I003 and found in PCAT - *
      *           delete from PCAT.                                   *
      *  ESL038 - ING STP Development                                 *
      *                                                               *
      *****************************************************************
     FFTPCATV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * Rtv : PCAT Base Information
     FFTPCEXV1  IF   E           K DISK
     F                                     Prefix(Ex_)
     F                                     INFSR(SRFILE)
      * Rtv : PCAT Extended Information
      *
     FFTPCATV0  UF A E           K DISK
     F                                     INFSR(SRFILE)
      * UPD : PCAT Base Information
     F/EJECT
      *
     D/COPY MECPYSRC,SRERRD_ILE
      *
      /COPY MECPYSRC,ME1100_ILE
      *
      *  Amount change array
     D YA1             S              1    DIM(15)
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      *  Copyright
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
      *  Data Structures used by Access Objects
      *
     D DsPcat        E DS                  EXTNAME(FTPCATV0)
      *
      *  PCAT Base Information
      *
     D DsPcex        E DS                  EXTNAME(FTPCEXV0)
     D                                     Prefix(Ex_)
      *
      *  PCAT Extended Information
      *
     D SvPcat        E DS                  EXTNAME(FTPCATV0)
     D                                     Prefix(Svp)
      *
      *  PCAT Base Information
      *
     D SvPcex        E DS                  EXTNAME(FTPCEXV0)
     D                                     Prefix(Sve)
      *
      *  PCAT Extended Information
      *
     D                 DS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * Data Structures used by Access Programs
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      * Switchable Features Data Structure *
      *

     D/EJECT
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *
     C     *ENTRY        PLIST
     C     R@IBAN        PARM                    I@IBAN           35
     C                   PARM                    P@RTN             6
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C     *LIKE         DEFINE    I@IBAN        R@IBAN
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Calculate date in ccyymmdd
      *
     C                   Call      'ZM0065'
     C                   Parm      WuRdnb        ZMDAY             5 0
     C                   Parm      *blanks       ZSDATE            6
     C                   Parm      *blanks       ZSDATC            8
      *
      * Check for PCAT on Midas
      *
     C     KPcatV0       Klist
     C                   Kfld                    PcIban
      *
     C                   Clear                   DsPcat
     C                   Clear                   DsPcEx
      *
     C                   Clear                   NoPcat            1
     C                   Clear                   NoExtension       1
      *
     C     KPcatV0       Chain     @PcatV1
     C                   If        %Found
     C     KPcatV0       Chain     @PcexV1
     C                   If        Not %Found
     C                   Eval      NoExtension = 'Y'
     C                   Endif
     C                   Else
     C                   Eval      NoPcat      = 'Y'
     C                   Eval      NoExtension = 'Y'
     C                   Endif
      *
     C                   Clear                   P@ReturnCode
     C                   Clear                   P@RTN
      *
     C     1             SUBST     I@IBAN        U#0001            1
     C     U#0001        IFEQ      '/'
     C                   Eval      PcIban = %Subst(I@IBAN:2:34)
     C                   ELSE
     C                   Eval      PcIban = %Subst(I@IBAN:1:34)
     C                   ENDIF
      *
     C                   Movel     PcIban        W@Ctry            2
     C                   If        W@Ctry <> 'PL'
     C     'PL'          Cat       PcIban:0      W@Iban           36
     C                   Movel(p)  W@Iban        PcIban
     C                   Endif
      *                                                                            MK0504
      * Call IBAN repair program.                                                  MK0504
     C                   MoveL(p)  PcIban        I#AcLn                            MK0504
      *                                                                            MK0504
     C                   Call      'FTP970'                                        MK0504
     C                   Parm                    P@ReturnCode      7               MK0504
     C                   Parm                    I#AcLn           35               MK0504
     C                   Parm      *Blanks       O#AcLn           35               MK0504
      *                                                                            MK0504
     C                   If        P@ReturnCode = *Blanks                          MK0504
     C                   MoveL(p)  O#AcLn        PcIban                            MK0504
     C                   EndIf                                                     MK0504
      *
      * Call ING Account Information Analysis
     C                   Call      'FT$I003'
     C*****              Parm                    P@ReturnCode      7               MK0504
     C                   Parm      *Blanks       P@ReturnCode      7               MK0504
     C     SvPcat        Parm      DsPcat        OutParm1       1024
     C     SvPcex        Parm      DsPcex        OutParm2       1024
     C                   Parm      NoPcat        OutParm3          1
     C                   Parm      NoExtension   OutParm4          1
      *
      *
      * Return data, if blanks then data found
b03  C                   IF        P@ReturnCode = '*found' and PcReci <> '*'
     C                   Eval      P@RTN = '*FOUND'
      *
     C                   Eval      DsPcat = SvPcat                                            MK0519
     C                   Eval      PCLudt = ZsDatc                                            MK0519
      * Update Pcat Information
     C     KPcatV0       Chain     @PcatV0
     C                   If        %Found
     C                   Eval      DsPcat = SvPcat                                            MK0519
     C                   Eval      PCLudt = ZsDatc                                            MK0519
     C                   Update    @PcatV0
     C                   Else
     C*****              Eval      DsPcat = SvPcat                                            MK0519
     C*****              Eval      PCLudt = ZsDatc                                            MK0519
     C                   Write     @PcatV0
     C                   Endif
      *
     C                   Movel(p)  Pciban        I@IBAN
      *
e02  C                   Endif
      *                                                                                       MK0503
     C                   If        P@ReturnCode <> '*found'                                   MK0503
      * Delete Pcat Information                                                               MK0503
     C     KPcatV0       Chain     @PcatV0                                                    MK0503
     C                   If        %Found                                                     MK0503
     C                   MOVE      'Y'           PROCESSED         1
     C                   Delete    @PcatV0                                                    MK0503
     C                   EndIf                                                                MK0503
     C                   EndIf                                                                MK0503
      *
      *  Exit program
      *
     C   U1              Dump
     C                   SETON                                        LR
     C                   RETURN
      *
     C/COPY MECPYSRC,SRERRC_ILE
**CTDATA CPY@
(C) Copyright Misys International Banking Systems Ltd. 2004
