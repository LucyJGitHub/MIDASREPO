     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001          ')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('CNAPS Code Details Report')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  XX000024 - CNAPS Code Details Report                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT110   *Create   Date 17Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT110 - Upgrade HUT022 to FBM 2.1 SP22.                     *
      *           RTGS Via SWIFT                                      *
      *                                                               *
      *****************************************************************
      *
     FXXCNAPL1  IF   E           K DISK
      ** CNAPS Code Details - Retrieve

     FXX000024P1O    E             PRINTER OFLIND(*IN10) USROPN
      ** CNAPS Code - Details Report
      *
      /EJECT
      *****************************************************************
      ** D-specs
      ** =======
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank Detail File

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Acess Objects
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D #COUNT          S              4  0
     D PRTCD           S              7
     D POPTN           S              7
      *
      /EJECT
      *****************************************************************
      ** Start of Main processing
      *****************************************************************
      *
     C                   Move      'Y'           WFIRSTD           1
     C                   Open      XX000024P1
     C                   Write     XX0024H1
      *
      ** Process CNAPS Code Detail file for printing
      *
     C     *Loval        Setll     XXCNAPL1
     C                   Read      XXCNAPL1                               75
     C     *IN75         DoWNe     *On

      ** Record counter
     C                   Add       1             #COUNT

      ** Clear detail record format for preparation
     C                   Clear                   XX0024D1

      ** Move fields from file to printer
      * CNAPS COde
     C                   Move      CNCODE        PRCODE
      * Bank Name
     C                   Movel     CNBKNM        PRBKNM
      * Branch Name
     C                   Movel     CNBRNM        PRBRNM
      * Customer
     C                   Movel     CNCUST        PRCUST
      * City
     C                   Movel     CNCITY        PRCITY
      * Address line 1
     C                   Movel     CNADR1        PRADR1
      * Address line 2
     C                   Movel     CNADR2        PRADR2
      * Address line 3
     C                   Movel     CNADR3        PRADR3

      ** Overflow indicator checking
     C                   If        *IN10 = *On
      * Header 1
     C                   Write     XX0024H1
      * Header 2
     C                   Write     XX0024H2
     C                   SetOff                                       10
      *
     C                   EndIf

      ** First detail header printing
     C                   If        WFIRSTD = 'Y'
     C                   Write     XX0024H2
     C                   Move      'N'           WFIRSTD
     C                   EndIf

      ** Details printing
     C                   Write     XX0024D1

      ** Process next available record
     C                   Read      XXCNAPL1                               75
     C                   Enddo

      **  When zero count, print No Detail otherwise End of Detail
      *
     C                   If        #COUNT = 0
     C                   Write     XX0024T1
     C                   Else
     C                   Write     XX0024T2
     C                   Endif
      *
     C                   Close     XX000024P1
      *
     C                   SetOn                                        LR
     C                   Return
      /EJECT
      *****************************************************************
     C     *Inzsr        Begsr
      *****************************************************************
      *
      **  Access Bank Details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      '*DBERR '     PRTCD
     C                   Parm      '*FIRST '     POPTN
     C     SDBANK        Parm      SDBANK        DSFDY
      *
     C                   Endsr

