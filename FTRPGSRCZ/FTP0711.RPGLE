     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Mapping for Mt101 to Mt103')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0711 - Midas FT Mapping for Mt101 to Mt103                *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2006       *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 EEE065   *CREATE   Date 16Mau2006             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
     D/COPY MECPYSRC,ME1100_ILE
      *
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTMA                 7     12
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D W#Vdat          S                   Like(TVVDAT)
     D W#ccy           S                   Like(TVCCY )
     D W#Amt           S                   Like(TVAMT )

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    PHead
     C                   PARM                    PData
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   MOVEL     PHMsgr        W0PREF
     C                   Exsr      SrInit

     C                   If        PMtpy = '101'
     C                   Exsr      Sr101to103
     C                   Endif
      * Exit
     C                   Return
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Sr101to103 : Mapping of 101 to 103                           *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   Sr101to103    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'Sr101to103'  @STK(Q)

      * 20  in header        - Sender's Reference

      * 21R in header        - Customer Specified Reference

      * 28D in header        - Message index/total

      * 50C or L in header   - Instructing Party
     C                   If        Ph50 = *blanks and
     C                             Ph50 <> *blanks
     C                   Eval      P50 = Ph50L
     C                   Endif

      * 50G or H in header   - Ordering Customer
     C                   If        Ph50 <> *blanks
     C                   Eval      P50 = Ph50
     C                   Endif

      * 52a in header        - Account Servicing Institution
     C                   If        Ph52 <> *blanks
     C                   Eval      P52 = Ph52
     C                   Endif

      * 51a in header        - Sending Institution

      * 30  in header        - Requested Execution Date
     C                   Eval      W#Vdat = 0
     C                   If        Ph30 <> *blanks
     C                   Eval      Dstran = Ph30
     C                   Eval      W#Vdat = TvVdat
     C                   Endif

      * 25  in header        - Authorisation

      * 21  in detail        - Transaction reference

      * 21F in detail        - FX Deal Reference

      * 23E in detail        - Instruction code

      * 32B in detail        - Currency and Amount
     C                   If        P32b <> *blanks
     C                   Eval      DsTran = P32b
     C                   Eval      W#Ccy  = %Subst(TvDca:1:3)
     C                   Eval      W#Amt  = %Subst(TvDca:4:16)
     C                   Eval      Dstran = PDCA
     C                   Eval      TvVdat = W#Vdat
     C                   Eval      TvCcy  = W#Ccy
     C                   Eval      TvAmt  = W#Amt
     C                   Eval      TrTag  = '32A'
     C                   Eval      PDca   = DsTran
     C                   Endif

      * 56a in detail        - Intermediary

      * 57a in detail        - Account with Institution

      * 59a in detail        - Beneficiary

      * 70  in detail        - Remittance Information

      * 77B in detail        - Regulatory Reporting

      * 33B in detail        - Original Ordered Currency and Amount

      * 71A in detail        - Details of Charges

      * 25A in detail        - Charges account

      * 36  in detail        - Exchange rate

      *
      *  Unwind subroutine stack name
      *
     C     Ex101to103    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrInit        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      * Define keys
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *================================================================
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
