     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Default Customer Details Country of Tax')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXDFT - SD Country of Tax Default for Private            *
      *              Individuals and Joint Accounts                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR811594*CREATE    Date 09Aug11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR811594 - Defaulf entry of Customer details by Country of   *
      *             Tax for a taxable customer is not automatically   *
      *             generated (Child: AR811595)                       *
      *                                                               *
      *****************************************************************
 
      ** SD Country of Tax Codes - Retrieve
     FSDCTTXL2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** Work Fields
     D KACTX           S              8A
     D KCOLC           S              2A
     D DDCUSN          S              6A
     D DDCOLC          S              2A
     D @RUN            S              1A
     D Idy             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array to hold Country of tax
     D CCTX8           S              8A   DIM(50)
 
      ** Data Structure for Country of tax
     D CCTXArrDS       DS
     D  CCTXArr                      51A   DIM(50)
 
     D TranInCCTX    E DS                  EXTNAME (SDCCTXDPD)
 
     D TranInCCTX1   E DS                  EXTNAME (SDCCTXPD)
 
      ** Data Structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Process Country of Tax Defaulting
     C                   EXSR      SRProcess
 
      ** Return
     C                   RETURN
 
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  SRProcess - Process Country of Tax Defaulting               *
      *                                                              *
      ****************************************************************
     C     SRProcess     BEGSR
 
      ** Initialise work variables
 
     C                   EVAL      CCTXArr = *BLANKS
     C                   EVAL      CCTX8   = *BLANKS
     C                   EVAL      Idy     = *ZEROS
 
      ** Access Country of Tax file with Country of Location
 
     C                   EVAL      KCOLC   = DDCOLC
     C     KCOLC         SETLL     SDCTTXL2
     C     KCOLC         READE     SDCTTXL2
 
     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EXSR      SRWrite
     C     KCOLC         READE     SDCTTXL2
     C                   ENDDO
 
      ** Access Country of Tax file without Country of Location
 
     C                   EVAL      KCOLC = *BLANKS
     C     KCOLC         SETLL     SDCTTXL2
     C     KCOLC         READE     SDCTTXL2
 
     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EXSR      SRWrite
     C     KCOLC         READE     SDCTTXL2
     C                   ENDDO
 
     C                   EVAL      TranInCCTX = CCTXArrDS
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWrite - Write details                                      *
      *                                                              *
      ****************************************************************
     C     SRWrite       BEGSR
 
     C                   CLEAR                   TranInCCTX1
 
     C                   EVAL      KACTX = DDCUSN + EWCTRT
 
     C     KACTX         LOOKUP    CCTX8                                  65
 
      ** Save record if not existing
 
     C                   IF        *IN65 = *OFF
 
     C                   EVAL      DDCUST = DDCUSN
     C                   EVAL      DDCTTX = EWCTRT
     C                   EVAL      DDETXS = EWTXS1
     C                   EVAL      DDCERF = *BLANKS
     C                   EVAL      DDCEEX = *BLANKS
     C                   EVAL      DDCSTS = 'A'
     C                   EVAL      DDCRTP = *BLANKS
     C                   EVAL      DDCADT = *BLANKS
     C                   EVAL      DDCVDT = *BLANKS
 
     C                   EVAL      Idy = Idy + 1
     C                   EVAL      CCTXArr(Idy) = TranInCCTX1
     C                   EVAL      CCTX8(Idy)   = KACTX
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Customer number
     C                   PARM                    DDCUSN
 
      ** Country of location
     C                   PARM                    DDCOLC
 
      ** CCTX API Format Definition
     C                   PARM                    TranInCCTX
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
