     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE PDCL RE/MR not generated report')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE007055 - Past Due Call Loans MR/RE events not generated    *
      *                                                               *
      *           The purpose of this function is to list PDCLs MR/RE *
      *           events that will not be generated because the block *
      *           all debit ind is Y.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CLE168             Date 26Feb18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR700107 *CREATE   Date 01Aug12               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  CLE168 - Allow Debit of Blocked Account                      *
      *  MD046248 - Finastra Rebranding                               *
      *  AR700107 - List PDCLs MR/RE events that will not be generated*
      *             because the block all debit indicator is Y.       *
      *             (Child: AR700108)                                 *
      *                                                               *
      *****************************************************************
     F/SPACE
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FLOAMSDK   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(K_)

      ** Customer Loans

     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L_)
     F                                     RENAME(CLOANCLF:CLOANORF)
     F                                     IGNORE(CLOANCKF) IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANZ1F)
     FLEFCLTLH  IF   E           K DISK    INFSR(*PSSR)                                       CLE168
     F                                     PREFIX(C_)                                         CLE168

     FLE007055P1O    E             PRINTER INFDS(SPOOL1)
     F                                     OFLIND(*IN50)

      *****************************************************************
     D/EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS

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

     D                 DS

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External Definitions

     D ZS2             S              1    DIM(21)
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short data structure for access objects.

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Long data structure for access objects.

     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Nostro details

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     D SPOOL1          DS
     D SFILE1                 83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Passed Parameters

      ** Parameters to LE07054

     D ILCNUM          S              6
     D CCYL            S              3
     D KSCCY           S              3
     D WBLCKD          S              1

      ** Overlays

      ** Fac. Fwd Drw Days

     D WVDAT6          S              6  0
     D WOSAC           S             18
     D WSETP           S              2  0

     D PSeq            S              5
     D PEnty           S              3
     D PSFile          S             10
     D PZSNum          S              6  0
     D PZSErr          S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Retrieve & Process Past Due Call Loan Details.

     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 021
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Print report header

     C                   WRITE     LE0705H1
     C                   WRITE     LE0705H2

      ** Process PDCLs

     C                   READ(E)   LOAMSDK
     C                   DOW       NOT %EOF(LOAMSDK)

     C                   IF        %SUBST(K_LTYP:1:1) = 'X' OR
     C                             %SUBST(K_LTYP:1:1) = 'Y' OR
     C                             %SUBST(K_LTYP:1:1) = 'Z'

      ** If Amendment type is 'RE' or 'MR' and value date is between
      ** run date and next working date

     C                   IF        K_VDAT >= BJRDNB AND K_VDAT < BJDNWD
     C                   IF        K_AMTP = 'RE' OR K_AMTP = 'MR'
     C     K_LNRF        CHAIN(E)  CLOAN
     C                   EXSR      SRRtvAcc
      *                                                                                       CLE168
      ** If CLE168 is switched on, check if facility is bankrupt                              CLE168
      *                                                                                       CLE168
     C                   MOVE      'N'           SKIPPRNT          1                          CLE168
     C                   IF        CLE168 = 'Y'                                               CLE168
     C                   EVAL      KFCUN = L_FCUS                                             CLE168
     C                   MOVE      L_FTYP        KFTYP                                        CLE168
     C                   MOVE      L_FSEQ        KFSEQ                                        CLE168
     C     LEFCLT1       CHAIN(E)  LEFCLTLH                                                   CLE168
     C                   IF        %FOUND(LEFCLTLH)                                           CLE168
     C                             AND C_FCBKPT = 'Y'                                         CLE168
     C                   MOVE      'Y'           SKIPPRNT                                     CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168

      ** If Block all debit is Y, then print record

     C                   IF        Wblckd = 'Y' AND L_AUTO = 'C'
      ** Continue printing if Facility is not Bankrupt                                        CLE168
      *                                                                                       CLE168
     C                   IF        SKIPPRNT = 'N'                                             CLE168
      *                                                                                       CLE168
     C                   EXSR      SRPrintR
      *                                                                                       CLE168
     C                   ENDIF                                                                CLE168
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   READ(E)   LOAMSDK
     C                   ENDDO

      ** Terminate Program

     C                   EVAL      *INLR = *ON

      ** Print report foot

     C                   WRITE     LE0705T1

     C                   RETURN

      *****************************************************************
     C/EJECT
      *****************************************************************
      *  srPrintR - Print Report                                      *
      *****************************************************************

     C     SRPrintR      BEGSR

      ** Clear work-fields

     C                   MOVE      K_LNRF        OLNRF
     C                   CLEAR                   OCPAM
     C                   CLEAR                   OINTD
     C                   CLEAR                   OTINTA
     C                   CLEAR                   OAMTP
     C                   CLEAR                   OVDAT

     C                   MOVE      '0'           OVDAT
     C                   MOVE      '0'           OCPAM
     C                   MOVE      '0'           OINTD
     C                   MOVE      '0'           OTINTA

      ** Set settlement account/type output field

     C     K_PTYP        IFNE      66
     C     K_PTYP        ANDNE     67
     C     K_PTYP        ANDNE     69
     C     K_PTYP        ANDNE     72
     C                   MOVE      K_RSTM        ORSTM
     C                   MOVEL     K_RONS        ORONS
     C                   ELSE
     C                   MOVE      K_PSTM        ORSTM
     C                   MOVEL     K_PONS        ORONS
     C                   ENDIF

      ** Get currency details

     C                   EXSR      SRGetCcy

      ** Principal

     C     K_PRAM        IFNE      0
     C                   Z-ADD     K_PRAM        ZFLD15
     C                   Z-ADD     A6NBDP        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OCPAM
     C                   ENDIF

      ** Interest

     C     K_INTA        IFNE      0
     C                   Z-ADD     K_INTA        ZFLD15
     C                   Z-ADD     A6NBDP        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OINTD
     C                   ENDIF

      ** Total Amount

     C     K_TAMT        IFNE      0
     C                   Z-ADD     K_TAMT        ZFLD15
     C                   Z-ADD     A6NBDP        Zdecs
     C                   MOVE      'J'           Zecode
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        OTINTA
     C                   ENDIF

      ** Value Date

     C     K_VDAT        IFNE      0
     C                   CALL      'ZDATE2'
     C                   PARM                    K_VDAT
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        WVDAT6
     C                   PARM      *BLANKS       OVDAT
     C                   ENDIF

      ** Print record

     C     PRtlN1        IFGE      60
     C                   WRITE     LE0705H1
     C                   WRITE     LE0705H2
     C                   ENDIF
     C                   WRITE     LE0705D1

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * srRtvAcc - Retrieve Account Details                           *
      *****************************************************************

     C     SRRtvAcc      BEGSR

     C                   MOVE      *BLANKS       WOSAC
     C                   MOVE      *BLANKS       WSETP

     C     K_PTYP        IFNE      66
     C     K_PTYP        ANDNE     67
     C     K_PTYP        ANDNE     69
     C     K_PTYP        ANDNE     72
     C                   MOVE      K_RONS        WOSAC
     C                   MOVE      K_RSTM        WSETP
     C                   ELSE
     C                   MOVE      K_PONS        WOSAC
     C                   MOVE      K_PSTM        WSETP
     C                   ENDIF

      ** Retrieve sett account and priority

     C                   MOVE      K_CNUM        ILCNUM
     C                   CALL      'LE007054'
     C                   PARM      K_CCY         CCYL
     C                   PARM                    ILCNUM
     C                   PARM      K_SCCY        KSCCY
     C                   PARM                    WOSAC
     C                   PARM                    WSETP
     C                   PARM                    L_OLNO
     C                   PARM                    K_OSBR

     C                   PARM      *BLANKS       WBLCKD

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
      * srGetCcy - Retrieve Currency Details                          *
      *****************************************************************

     C     SRGetCcy      BEGSR

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    K_CCY
     C     SDCURR        PARM                    DSSDY

     C                   ENDSR

      *****************************************************************
      * SRRCFProc - Register Printer File via RCF                     *
      *****************************************************************

     C     SRRCFProc     BEGSR

     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANKS       PZSErr

      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.

     C                   IF        PZSErr = 'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************

     C     *INZSR        BEGSR


     C                   MOVEL     SFILE1        PSFile
     C                   Z-ADD     SFNUM1        PZSNum
     C                   EXSR      SRRCFProc
      *                                                                                       CLE168
      ** Check if CLE168 is switched on                                                       CLE168
      *                                                                                       CLE168
     C                   MOVE      *BLANKS       CLE168            1                          CLE168
     C                   CALL      'AOSARDR0'                                                 CLE168
     C                   PARM      *BLANKS       @RTCD             7                          CLE168
     C                   PARM      '*VERIFY'     @OPTN             7                          CLE168
     C                   PARM      'CLE168'      @SARD             6                          CLE168
      *                                                                                       CLE168
     C                   IF        @RTCD = *BLANKS                                            CLE168
     C                   EVAL      CLE168 = 'Y'                                               CLE168
     C                   ENDIF                                                                CLE168
      *                                                                                       CLE168
      *                                                                                       CLE168
     C     LEFCLT1       KLIST                                                                CLE168
     C                   KFLD                    KFCUN             6                          CLE168
     C                   KFLD                    KFTYP             3                          CLE168
     C                   KFLD                    KFSEQ             2                          CLE168
      *                                                                                       CLE168

     C                   ENDSR

      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZSRSRC,ZSEDITZ3LE
     C/COPY ZACPYSRC,PSSR_ILEB
      *****************************************************************
     C/EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
