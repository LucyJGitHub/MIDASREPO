     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Convert Outgoing Payments SSI Details')       *
      **********************************************************************
      *                                                                    *
      *  Midas - API Funds Transfer Module                                 *
      *                                                                    *
      *  FTOPSICVT - Outgoing Payments SSI Convert Module                  *
      *                                                                    *
      *  Function:  This converts details of Funds Transfer Outgoing       *
      *             Payments Standard Settlement Instructions from         *
      *             file format to screen format.                          *
      *                                                                    *
      *  (c) Finastra International Limited 2002                           *
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CFT018   *CREATE   Date 20Oct02               *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CFT018 - Standard Settlement Instructions for Funds Transfer      *
      *           Outgoing Payments                                        *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *
      *****************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
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
      *
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
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScnFmt     E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for currency codes
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D CFT120          S              1A                                                      CFT120
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
      *
      ** Initialisation
     C                   Exsr      INIT
      *
      *
      **  Convert details from file format layout to screen format layout
     C                   Exsr      CvtFields
      *
      **  Return to calling program
     C                   Return
      *
      /EJECT
      *****************************************************************
      * INIT - Initialisation Processing each time module is invoked
      *****************************************************************
     C     INIT          BEGSR
      *
      **  Get pay currency decimal places
     C                   Move      OSCRCY        WCURCY            3
     C                   Z-Add     1             WERNB             3 0
     C                   Exsr      GetCcy
     C                   Z-add     A6NBDP        WpayDec           1 0
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * CvtFields - Move values from file layout to screen layout
      *****************************************************************
     C     CvtFields     Begsr
      *
      **  Debit currency
     C                   Move      OSDRCY        SDRCY
      *
      **  Debit account
     C                   Move      OSDRAC        SDRAC
      *
      **  Reference I
     C                   Move      OSREF1        SREF1
      *
      **  Reference II
     C                   Move      OSREF2        SREF2
      *
      **  Pay currency
     C                   Move      OSCRCY        SCRCY
      *
      **  Description
     C                   Move      OSDESC        SDESC
      *
      **  Payment type and sub-type
     C                   Move      OSPYTP        SPYTP
     C                   Move      OSPYST        SPYST
      *
      **  Booking branch code.
     C                   Move      OSBRCA        SBRCA
      *
      **  Originating branch
     C                   Move      OSORBR        SORBR
      *
      **  Settlement type
     C                   Move      OSSTMT        SSTMT
      *
      **  Swift Priority.
     C                   Move      OSSWPC        SSWPC
      *
      **  Destination
     C                   Move      OSDST1        SDST1
     C                   Move      OSDST2        SDST2
     C                   Move      OSDST3        SDST3
     C                   Move      OSDST4        SDST4
      *
      **  MT100 Customer.
     C                   Movel     OSODMT        SODMT
      *
      **  Ordering Customer.
     C                   Move      OSORC1        SORC1
     C                   Move      OSORC2        SORC2
     C                   Move      OSORC3        SORC3
     C                   Move      OSORC4        SORC4
     C                   Move      OSORC5        SORC5                                      BUG14716
      *
      **  Sender's Correspondent
     C                   Move      OSSNCO        SSNCO
      *
      **  Ordering Bank and Branch Code
     C                   Move      OSORBK        SORBK
     C     @MBIN         Ifeq      'Y'
     C                   Move      OSORBB        SORBB
     C                   Endif
      *
      **  Send MT202
     C                   Move      OSSNMT        SSNMT
      *
      **  Date offset code
     C                   Move      OSOFCD        SOFCD
      *
      **  Add/Deduct Indicator
     C                   Move      OSADDC        SADDC
      *
      **  Book code
     C                   Move      OSBOKC        SBOKC
      *
      **  Profit Centre
     C                   Move      OSPRFC        SPRFC
      *
      **  Receivers Correspondent
     C                   Move      OSRCO1        SRCO1
     C                   Move      OSRCO2        SRCO2
     C                   Move      OSRCO3        SRCO3
     C                   Move      OSRCO4        SRCO4
     C                   Move      OSRCO5        SRCO5
      *
      ** Third Reimbursement Institution
     C                   Movel     OSTRI1        STRI1
     C                   Movel     OSTRI2        STRI2
     C                   Movel     OSTRI3        STRI3
     C                   Movel     OSTRI4        STRI4
     C                   Movel     OSTRI5        STRI5
      *
      **  Intermediary Bank
     C                   Move      OSINB1        SINB1
     C                   Move      OSINB2        SINB2
     C                   Move      OSINB3        SINB3
     C                   Move      OSINB4        SINB4
     C                   Move      OSINB5        SINB5
      *
      **  Account with Bank
     C                   Move      OSACB1        SACB1
     C                   Move      OSACB2        SACB2
     C                   Move      OSACB3        SACB3
     C                   Move      OSACB4        SACB4
     C                   Move      OSACB5        SACB5
      *
      **  Beneficiary
     C                   Move      OSBNC1        SBNC1
     C                   Move      OSBNC2        SBNC2
     C                   Move      OSBNC3        SBNC3
     C                   Move      OSBNC4        SBNC4
     C                   Move      OSBNC5        SBNC5
      *
      **  Details of Payment
     C                   Move      OSDTP1        SDTP1
     C                   Move      OSDTP2        SDTP2
     C                   Move      OSDTP3        SDTP3
     C                   Move      OSDTP4        SDTP4
      *
      **  Bank to Bank information
     C                   Move      OSBBI1        SBBI1
     C                   Move      OSBBI2        SBBI2
     C                   Move      OSBBI3        SBBI3
     C                   Move      OSBBI4        SBBI4
     C                   Move      OSBBI5        SBBI5
     C                   Move      OSBBI6        SBBI6
      *
      **  Central Bank Reference.
     C     OSDNBC        Ifne      0
     C                   Move      OSDNBC        SDNBC
     C                   Else
     C                   Move      *BLANKS       SDNBC
     C                   Endif
      *
      **  Transfer Comission tariff
     C                   Move      OSTRCT        STRCT
      *
      **  Instruction Codes
     C                   Movel     OSICD1        SICD1
     C                   Movel     OSICD2        SICD2
     C                   Movel     OSICD3        SICD3
     C                   Movel     OSICD4        SICD4
     C                   Movel     OSICD5        SICD5
      *
      **  Regulatory Reporting
     C                   Movel     OSRRP1        SRRP1
     C                   Movel     OSRRP2        SRRP2
     C                   Movel     OSRRP3        SRRP3
      *
      **  Charges to Debit of Account and Branch
     C     OSCDRO        Ifeq      *Zeros
     C     CFT120        ANDEQ     'N'                                                        CFT120
     C     OSCDRO        OREQ      *Zeros                                                     CFT120
     C     OSCDRO        ANDEQ     *Blanks                                                    CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C                   Move      *Blanks       SCDRO
     C                   Else
     C                   Move      OSCDRO        SCDRO
     C                   Endif
     C                   Move      OSCDBR        SCDBR
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Move      OSCDRC        SCDRC                                        CFT120
     C                   ENDIF                                                                CFT120
      *
      **  Details of Charges
     C                   Move      OSDTCH        SDTCH
      *
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * GetCCY   - Get currency details                               *
      *****************************************************************
     C     GetCcy        BegSr
      *
     C                   Callb     'AOCURRR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      WCURCY        @AJCD             3
     C     SDCURR        Parm      SDCURR        DSSDY
      *
      ** Error found on call
     C                   If        @RTCD <> *Blank
     C                   Movel     'AOCURRR0'    DBFILE
     C                   Z-Add     WERNB         DBASE
     C                   Movel     WCURCY        DBKEY
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   EndSr
      /EJECT
      *****************************************************************
      * FmtAmt - Format Amount for Dispaly                            *
      *****************************************************************
     C     FmtAmt        Begsr
      *
     C                   Callb     'ZA0920'
     C                   Parm      *BLANK        @@RETC           10
     C                   Parm                    @@AMTW           13 0
     C                   Parm                    @@QECN            1 0
     C                   Parm      '.'           BNDCSP            1
     C                   Parm      *BLANK        @@AMTD           14
      *
     C                   Endsr
      *****************************************************************
      *****************************************************************
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm                    RetCodeOut
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScnFmt
      *
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD             7                          CFT120
     C                   PARM      '*VERIFY'     @OPTN             7                          CFT120
     C                   PARM      'CFT120'      @SARD             6                          CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD <> '*NRF '                                           CFT120
      *                                                                                       CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 001                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
