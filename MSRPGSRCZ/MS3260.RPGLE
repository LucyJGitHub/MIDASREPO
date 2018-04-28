     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/**TD****RPGBND********************************************************                       146340
/**TD ***RPGBNDACT*****************************************************                146340 148455
/*STD *  RPGBASEBND                                                   *                       148455
/*EXI *  TEXT('Midas MS incoming messages database update')           *
      *****************************************************************
      *                                                               *
      *  Midas/SWIFT Direct Link Module                               *
      *                                                               *
      *  MS3260 - Incoming messages database update                   *
      *                                                               *
      *  Function:  This program reads incoming messages in DOS-PCC   *
      *             format from each member of PF/MSPCCIPD, converts  *
      *             them to EBCDIC and writes them to the Midas       *
      *             incoming messages database.                       *
      *                                                               *
      *  Called By: MSC3250 - Alliance automated receive              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR976772           Date 23May12               *
      *  Prev Amend No. CSW212             Date 03May12               *
      *                 252317             Date 15Feb08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CMS001             Date 13Feb06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Plus 1.2 ---------------- Base -------------------------*
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CTI004             Date 12Apr04               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185771             Date 08Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187213             Date 21Nov00               *
      *                 186477             DATE 17Nov00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 184427             DATE 02Oct00               *
      *                 184013             DATE 20Sep00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 148455             DATE 23Nov98               *
      *                 146340             DATE 29Oct98               *
      *                 140532             Date 11Aug98               *
      *                 125554             Date 19Nov97               *
      *                 125710             Date 07Nov97               *
      *                 CSW009 *CREATE     Date 03MAR97               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR976772 - Value date century is not populated for all types *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  252317 - Increase branches array size from 99 to 999.        *
      *           If BIC code ends in 'XXX' and BIC is not found in   *
      *           SDBRCHPD then use default branch                    *
      *           (i.e. branch of bank's internal customer)           *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CMS001 - Always default branch to system value parameter     *
      *           when CMS001 is on. Use AOSVALR0 to retrieve parm    *
      *           (Midas Plus 1.2 Upgrade)                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CTI004 - MidasPlus-TI Integration Enhancements               *
      *           Routing Swift Messages                              *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  185771 - MT580's not LACK'd or NACK'd                        *
      *  187213 - Support block 3 processing for TI Interface         *
      *  186477 - MS3260 crashes when receiving SWIFT2000 MT350s      *
      *  CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD)  *
      *  184427 - Add MT340s and MT360s                               *
      *  184013 - Swift 2000 get correct date format from 30V         *
      *  148455 - Reverse out 146340 as RPGBND has been changed to    *
      *           match RPGBNDACT.                                    *
      *  146340 - Set up century field for year 2000 and use new      *
      *           creation parameters.                                *
      *  140532 - SWIFT98 fix                                         *
      *           Crashes if incoming message contains :20C: instead  *
      *           of :20:. Format of :20C: is :20C::CCCC//TRN...      *
      *  125554   Data in fields :32 , :34 , :19 , :30 , :25 being    *
      *           corrupted due to incorrect start position in array. *
      *  125710   End of text Ctrl-C character being overwritten with *
      *           a blank character.                                  *
      *           Remove line to enable CtrlC character.              *
      *  CSW009 - Midas-SWIFT Alliance Automated File Transfer        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Notes:                                                       *
      *  ------                                                       *
      *                                                               *
      *  1. Formatted SWIFT messages are converted to EBCDIC before   *
      *     any further Midas processing is performed. Standard FTP   *
      *     conversion is not used because it doesn't convert CrLf.   *
      *     File transfer type 'I' (image) is specified in the FTP    *
      *     script file to disable standard conversion.               *
      *                                                               *
      *  2. Each message file on Alliance is written to a different   *
      *     member of PF/MSPCCIPD. CL component MSC3250 performs the  *
      *     necessary overrides for this programs to access each      *
      *     member in turn.                                           *
      *                                                               *
      *****************************************************************
      /EJECT
     FMSPCCIPD  IF   E           K disk    infsr(srfile)
     FSDBRCHL0  IF   E           K disk    infsr(srfile)
     FSDCUSTL7  IF   E           K disk    infsr(srfile)
     FMSMSI2L9  IF   E           K disk    infsr(srfile)
     F                                     rename(msmsi2d0:msmsi2d9)
     FMGOREFL0  UF   E           K disk    infsr(srfile)
     F                                     commit
     F/COPY WNCPYSRC,MS3260F001
     FMSIXI2PD  O    E           K disk    infsr(srfile)
     F                                     commit
     FMSMSI2PD  O    E           K disk    infsr(srfile)
     F                                     commit
     FMGOMSGLD  IF   E           K disk    infsr(srfile)                                      185771
      /EJECT
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
      *
     D*tabtyp**********S              3    dim(15) ctdata perrcd(1)             184427
     D*tabcas**********S              1    dim(15) alt(tabtyp)                  184427
     D*tabtyp**********S              3    dim(20) ctdata perrcd(1)                    184427 CSW212
     D*tabcas**********S              1    dim(20) alt(tabtyp)                         184427 CSW212
     D tabtyp          S              3    dim(22) ctdata perrcd(1)                           CSW212
     D tabcas          S              1    dim(22) alt(tabtyp)                                CSW212
      ** Message type specific processes
      *
     D tabty2          S              3    dim(1) ctdata perrcd(1)                            CSW212
     D tabamc          S             10    dim(1) alt(tabty2)                                 CSW212
      ** Message tag and qualifier for amount/currency                                        CSW212
      *                                                                                       CSW212
     D tabty3          S              3    dim(1) ctdata perrcd(1)                            CSW212
     D tabdat          S             10    dim(1) alt(tabty3)                                 CSW212
      ** Message tag and qualifier for value date                                             CSW212
      *                                                                                       CSW212
     D tabmonn         S              2    dim(12) ctdata perrcd(1)
     D tabmona         S              3    dim(12) alt(tabmonn)
      ** Month code by month number (eg. 01 JAN)
      *
     D ar1             S              4    dim(14) ctdata perrcd(1)                           CSW209
     D ar2             S              1    dim(14) alt(ar1)                                   CSW209
      ** Escape Sequence Translation Array                                                    CSW209
      *                                                                                       CSW209
     D*br@midas*       S              3    dim(99)                                            252317
     D*br@swift*       S             11    dim(99)                                            252317
     D br@midas        S              3    dim(999)                                           252317
     D br@swift        S             11    dim(999)                                           252317
      ** Midas branch code v SWIFT branch code
      *
     D dsfdy         E DS                  extname(DSFDY)
     D dssdy         E DS                  extname(DSSDY)
      ** Data Structures used by access objects
      *
     D sdbank        E DS                  extname(SDBANKPD)
      ** Bank details ICD
      *
     D sdmmod        E DS                  extname(SDMMODPD)
      ** Bank details data area
     D/COPY WNCPYSRC,MS3260D002
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CTI004
      ** DS for SC Switchable Features                                                        CTI004
                                                                                              CTI004
     D sdmgme        E DS                  extname(SDMGMEPD)
      ** Message Generation/Message Management ICD
      *
     D medta         E DS                  extname(MEDTA)
      ** Message Management data area
     D/COPY WNCPYSRC,MS3260D001
      *
     D                 DS
     Dw@msgbuf1                1  12001
     Dw@msgbuf                 2  12001
      ** Incoming message buffer (w@msgbuf excludes start-of-text)
      *
     D w@b2dta         DS            46
     D  w@mtpy                 1      3
     D  w@96n                  1      2
     D  tme                    4      7
     D  MIR                    8     35
     D  w@sndad               14     21
     D  w@sndbr               23     25
     D  MODE                  36     41  0
     D  MOTM                  42     45  0
     D  w@mpry                46     46
      ** Split up Block 2 of incoming message
      *
     D                 DS
     D  MOR                    1     28
     D  w@mord                 1      6
     D  w@dstad                7     14
     D  w@dstbr               16     18
     D  w@morr                 7     28
      ** Message Ouput Reference (MOR)
      *
     D                 DS
     D  A8BTID                 1     12
     D  w@brad                 1      8
     D  w@brbr                10     12
      ** Split up branch TID
      *
     D                 DS
     D  w@mode                 1      6
     D  w@year                 1      2
     D  w@month                3      4
     D  w@day                  5      6
      ** Message output date
      *
     D                 DS
     D  w@latm                 1      6  0
     D  w@motm                 1      4
     D  w@zz                   5      6    inz('00')
      ** Message output time and last action time
      *
     D                 DS
     D  k@clikey               1     12
     D  k@cliad                1      8
     D  k@clibr                9     11
      ** Key for access to Customer Details
      *
     D                 DS
     D  w@cr                   1      1    inz(x'0d')
     D  w@lf                   2      2    inz(x'25')
     D  w@crlf                 1      2
     D  w@stag                 3      5                                                       125554
     D  w@scan                 1      5                                                       125554
      *
     Dw@soh            S              1    inz(x'01')
     Dw@etx            S              1    inz(x'03')
      ** Control codes: Carriage-returnLine-feed, Start-of-Text, End-of-Text
      *                                                                                       CSW209
     Dcsw209           S              1    inz('N')                                           CSW209
      ** CSW209 switch                                                                        CSW209
      *                                                                                       CSW209
     Dw@c1             S              5  0 inz(*zero)                                         CSW209
     Dw@c2             S              5  0 inz(*zero)                                         CSW209
     Dw@c3             S              5  0 inz(*zero)                                         CSW209
     Dw@chr            S              1    inz(*blank)                                        CSW209
     Dz                S              2  0 inz(*zero)                                         CSW209
     Dw@f1             S          12000    inz(*blank)                                        CSW209
     Dw@f2             S          12000    inz(*blank)                                        CSW209
     Dw@f3             S          12000    inz(*blank)                                        CSW209
     Dw@f4             S          12000    inz(*blank)                                        CSW209
      ** Work field for the processing of Escape Translation                                  CSW209
      *
     D digits          C                   '0123456789'                                       CSW212
                                                                                              CTI004
      ** Declared variables for enhancement CTI004                                            CTI004
                                                                                              CTI004
     D PMSGBUF         S           9999                                                       CTI004
     D PMTPY           S              3                                                       CTI004
     D POKFLG          S              1                                                       CTI004
     D CTI004          S              1                                                       CTI004
     D PRTCD           S              7                                                       CTI004
     D POPTN           S              7                                                       CTI004
     D PSARD           S              6                                                       CTI004
                                                                                              CTI004
      ** Declared variable for enhancement CMS001                                             CMS001
                                                                                              CMS001
     D CMS001          S              1                                                       CMS001
                                                                                              CMS001
      /COPY MSCPYSRC,SRERRD
      /EJECT
      *****************************************************************
      *  Index to Subroutines                                         *
      *                                                               *
      *  sr_init       : Initialise program and session               *
      *  sr_detail     : Detail processing                            *
      *  sr_esctr      : Process Escape Sequence Translations         *                       CSW209
      *  sr_msg        : Write incoming message to database           *
      *  sr_ix         : Generate index (reference) record            *
      *  sr_typa       : Process incoming messages of type A          *
      *  sr_typb       : Process incoming messages of type B          *
      *  sr_typc       : Process incoming messages of type C          *
      *  sr_typd       : Process incoming messages of type D          *
      *  sr_rpt        : Process report (ACK / NAK)                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Output parameter: o@msgs = 'Y' if any messages found, else 'N'
     C     *entry        plist
     C                   parm                    o@msgs            1
      *
      ** Set up copyright parameter
     C                   movea     cpy@          cpy2@            80
      *
      ** Initialise program
     C                   exsr      sr_init
      *
      ** Access incoming messages, convert and write to file
     C                   exsr      sr_detail
      *
      ** Terminate
     C                   move      *on           *inlr
      /EJECT
      **********************************************************************
      * sr_detail      : Detail processing: access incoming messages       *
      * ---------        and write to Midas database.                      *
      *                                                                    *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls**********:*-**************************************************                  CSW209
      * Calls          : sr_esctr                                          *                  CSW209
      *                                                                    *
      **********************************************************************
      *
     C     sr_detail     begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_detail'   @STK(Q)
      *
     C                   read      mspccid0                               50
     C     *in50         doweq     *off
      *
      ** Convert incoming message data from ASCII to EBCDIC using API
     C                   call      'QDCXLATE'
     C                   parm      512           p@lngth           5 0
     C                   parm      SIDATA        p@buf           512
     C                   parm      'QTCPEBC'     p@tblin          10
     C                   parm      'QUSRSYS'     p@libin          10
      *
      ** test for end-of-text (*in55) before replacing with blank
     C     w@etx         scan      p@buf                                  55
     C     *in55         ifeq      '1'
     C*****w@etx:'*'**** xlate     p@buf         p@buf                                        125710
     C                   endif
      *
      ** Add data to incoming message buffer
     C                   cat       p@buf:0       w@msgbuf1
      *
      ** If this record contains end-of-text this is the last record of a
      ** message or report (ACK/NAK) so update the database
     C     *in55         ifeq      *on
      *                                                                                       CSW209
      ** Scan message for Escape Sequence Translation                                         CSW209
     C     csw209        ifeq      'Y'                                                        CSW209
     C                   exsr      sr_esctr                                                   CSW209
     C                   endif                                                                CSW209
      *
     C     '{2:'         scan      w@msgbuf      p                 5 0
     C                   add       3             p
     C     1             subst     w@msgbuf:p    w@io              1
      *
     C     w@io          caseq     'O'           sr_msg
     C                   cas                     sr_rpt
     C                   endcs
      *
      ** re-initialise buffer for next message
     C                   clear                   w@msgbuf1
     C                   endif
     C/COPY WNCPYSRC,MS3260C006
      *
     C                   read      mspccid0                               50
     C                   enddo
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************                  CSW209
      * sr_esctr       : Process Escape Sequence Translations              *                  CSW209
      * ------                                                             *                  CSW209
      *                                                                    *                  CSW209
      * Called by      : sr_detail                                         *                  CSW209
      *                                                                    *                  CSW209
      * Calls          :                                                   *                  CSW209
      *                                                                    *                  CSW209
      **********************************************************************                  CSW209
      *                                                                                       CSW209
     C     sr_esctr      begsr                                                                CSW209
      *                                                                                       CSW209
      ** Push subroutine                                                                      CSW209
     C                   add       1             Q                                            CSW209
     C                   movel     'sr_esctr'    @STK(Q)                                      CSW209
      *                                                                                       CSW209
     C                   eval      w@f1 = w@msgbuf                                            CSW209
     C                   eval      z = 1                                                      CSW209
      *                                                                                       CSW209
     C                   dow       z < 15                                                     CSW209
      *                                                                                       CSW209
     C     ar1(z)        scan      w@f1          w@c1                     89                  CSW209
     C                   dow       *in89 = *on                                                CSW209
      *                                                                                       CSW209
     C                   eval      w@chr = ar2(z)                                             CSW209
     C                   if        w@c1 = 1                                                   CSW209
      *                                                                                       CSW209
     C                   eval      w@c3 = w@c1 + 4                                            CSW209
     C                   subst     w@f1:w@c3     w@f3                                         CSW209
     C     w@chr         cat       w@f3:0        w@f4                                         CSW209
     C                   else                                                                 CSW209
      *                                                                                       CSW209
     C                   eval      w@c2 = w@c1 - 1                                            CSW209
     C     w@c2          subst     w@f1          w@f2                                         CSW209
     C                   eval      w@c3 = w@c1 + 4                                            CSW209
     C                   subst     w@f1:w@c3     w@f3                                         CSW209
     C                   move      *blanks       temp              1                          CSW209
     C                   move      w@c2          pos               5 0                        CSW209
     C                   eval      temp = %subst(w@f1:pos)                                    CSW209
     C                   move      0             ctr               1 0                        CSW209
      *                                                                                       CSW209
     C                   dow       temp = ' '                                                 CSW209
     C                   add       1             ctr                                          CSW209
     C                   sub       1             pos                                          CSW209
     C                   eval      temp=%subst(w@f1:pos)                                      CSW209
     C                   enddo                                                                CSW209
      *                                                                                       CSW209
     C     w@f2          cat       w@chr:ctr     w@f2                                         CSW209
     C     w@f2          cat       w@f3:0        w@f4                                         CSW209
     C                   endif                                                                CSW209
      *                                                                                       CSW209
     C                   eval      w@f1 = w@f4                                                CSW209
     C                   eval      w@f2 = *blanks                                             CSW209
     C                   eval      w@f3 = *blanks                                             CSW209
     C                   eval      w@f4 = *blanks                                             CSW209
     C     ar1(z)        scan      w@f1          w@c1                     89                  CSW209
     C                   enddo                                                                CSW209
      *                                                                                       CSW209
     C                   eval      z = z + 1                                                  CSW209
     C                   enddo                                                                CSW209
      *                                                                                       CSW209
     C                   eval      w@msgbuf = w@f1                                            CSW209
      *                                                                                       CSW209
      ** Pop subroutine                                                                       CSW209
     C                   clear                   @STK(Q)                                      CSW209
     C                   sub       1             Q                                            CSW209
     C                   endsr                                                                CSW209
      /EJECT                                                                                  CSW209
      **********************************************************************
      * sr_msg         : Write incoming message to database                *
      * ------                                                             *
      *                                                                    *
      * Called by      : sr_detail                                         *
      *                                                                    *
      * Calls          : sr_ix                                             *
      *                                                                    *
      **********************************************************************
      *
     C     sr_msg        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_msg'      @STK(Q)
      *
      ** Clear message data file formats
     C                   clear                   msmsi2d0
     C                   clear                   msixi2d0
      *
      ** Set up Message Input Reference, and check for duplication
      ** (w@b2dta splits up block {2: - see 'D' spec)
     C     '{2:O'        scan      w@msgbuf      w@1               7 0
     C                   add       4             w@1
     C     46            subst     w@msgbuf:w@1  w@b2dta
     C                   movel     w@mpry        MPRY
     C                   movel     w@mtpy        MTPY
      *                                                                                       146340
      ** Set up Century field                                                                 146340
     C                   movel     MODE          cent              2                          146340
     C     cent          iflt      '72'                                                       146340
     C                   move      '20'          MODEC                                        146340
     C                   else                                                                 146340
     C                   move      '19'          MODEC                                        146340
     C                   endif                                                                146340
      *
     C     MIR           setll     msmsi2d9                               60
      *
      ** If message is not a duplicate and is of a recognised type update
      ** database
     C     *in60         ifeq      *off
     C     w@mtpy        andge     '100'
     C     w@mtpy        andle     '999'
     C     w@96n         andne     '96'
     C/COPY WNCPYSRC,MS3260C001
      *
      ** Set up the MOR date from the incoming date
     C                   move      MODE          w@mord
      *
      ** Locate Block {1: of the message for the remaining
      ** components of the MOR
     C     '{1:'         scan      w@msgbuf      w@1
     C                   add       6             w@1
     C     22            subst     w@msgbuf:w@1  w@morr
      *
      ** Create message index
     C                   exsr      sr_ix
      *
      ** Set message-processed flag
     C                   movel     'Y'           MSPF
      *
      ** Write all data records to message data file
     C     '{1:'         scan      w@msgbuf:2    w@1
     C/COPY WNCPYSRC,MS3260C002
     C     256           subst     w@msgbuf:w@1  MDTA
     C     MDTA          downe     *blanks
     C                   write     msmsi2d0
     C                   add       256           w@1
     C     256           subst     w@msgbuf:w@1  MDTA
     C                   enddo
      *
      ** Commit transaction (message) : all data + index
     C                   commit
     C/COPY WNCPYSRC,MS3260C005
      *
      ** Update received network information
     C     *dtaara       define                  medta
     C     *lock         in        medta
     C                   movel     MOR           DAMOR
     C                   movel     MIR           DAMIR
     C                   out       medta
      *
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_ix          : Generate index (reference) record for incoming    *
      * -----            message.                                          *
      *                                                                    *
      * Called by      : sr_msg                                            *
      *                                                                    *
      * Calls          : sr_typa                                           *
      *                  sr_typb                                           *
      *                  sr_typc                                           *
      *                  sr_typd                                           *
      *                  sr_type                                           *                  CSW212
      *                                                                    *
      **********************************************************************
      *
     C     sr_ix         begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_ix'       @STK(Q)
      *
      ** Attempt to match destination address with branch address details
      ** from Branch Codes file to determine Midas branch.
     C                   movel     w@dstad       w@try            11
     C                   move      w@dstbr       w@try
     C                   z-add     1             w@b
     C     w@try         lookup    br@swift(w@b)                          80
     C     *in80         ifeq      *on
     C                   IF        CMS001 =  'Y'                                         B1   CMS001
     C                   movel     DftBrch       BRCA                                         CMS001
     C                   else                                                            X1   CMS001
     C                   movel     br@midas(w@b) BRCA
     C                   endif                                                           E1   CMS001
     C/COPY WNCPYSRC,MS3260C007
     C                   endif
      ** If BIC code ends in 'XXX' then use default branch                                    252317
      **    and not found in the SDBRCHPD file                                                252317
     C                   if        *in80  = *off and                                          252317
     C                             w@brbr = 'XXX'                                             252317
     C                   move      dftbrch       BRCA                                         252317
     C                   end                                                                  252317
      *
      ** Attempt to locate Midas customer number: if found, store 'suppress
      ** download to AutoRecs II' flag.
     C                   move      w@sndad       k@cliad
     C                   move      w@sndbr       k@clibr
     C                   clear                   w@ssdl            1
     C     k@clikey      chain     sdcustl7                           81
     C     *in81         ifeq      *on
     C     k@clibr       andeq     'XXX'
     C                   clear                   k@clibr
     C     k@clikey      chain     sdcustl7                           81
     C                   endif
     C     *in81         ifeq      *off
     C                   move      BBCUST        CNUM
     C                   move      BBSSDL        w@ssdl
     C                   endif
     C                   move      k@clikey      STID
      *
      ** Locate TRN
     C*****':20:'        scan      w@msgbuf      w@1                                          140532
     C     ':20:'        scan      w@msgbuf      w@1                      65                  140532
     C     *in65         ifeq      *off                                                       140532
     C     ':20C:'       scan      w@msgbuf      w@1                      65                  140532
     C                   add       8             w@1                                          140532
     C                   endif                                                                140532
      *
      ** Scan for the end of the TRN
     C     w@crlf        scan      w@msgbuf:w@1  w@2               7 0
      *
      ** Calculate the length of the TRN
     C                   add       4             w@1
     C     w@2           sub       w@1           w@ln              7 0
      *
      ** Move the TRN into the reference record field
     C                   clear                   w@trno           16
     C     w@ln          subst     w@msgbuf:w@1  w@trno
      *
      ** Determine message type, and process appropriately
     C     MTPY          lookup    tabtyp        tabcas                   82
     C     *in82         ifeq      *on
     C     tabcas        caseq     'A'           sr_typa
     C     tabcas        caseq     'B'           sr_typb
     C     tabcas        caseq     'C'           sr_typc
     C     tabcas        caseq     'D'           sr_typd
     C     tabcas        caseq     'E'           sr_type                                      CSW212
     C                   end
     C                   else
     C                   clear                   FD25
     C                   clear                   SVDT
     C                   clear                   AMTS
     C                   clear                   CCY
     C                   endif
      *
      ** Perform AutoRecs II processing if module is switched on
     C     BGAURC        ifeq      'Y'
      *
      ** If message is statement (940, 950) and 'suppress download to
      ** AutoRecs II' is not set for customer, set up download details.
     C     MTPY          ifeq      '940'
     C     w@ssdl        andne     'Y'
     C     MTPY          oreq      '950'
     C     w@ssdl        andne     'Y'
     C                   TIME                    R3STIM
     C                   movel     'A'           R3RPTS
     C                   z-add     BJRDNB        R3SDAT
     C                   movel     ##JOB         R3LJOB
     C                   movel     ##USR         R3LUSR
     C                   movel     ##JNO         R3LJNO
     C                   endif
      *
     C                   endif
      *
      ** Output record to MSIXI2PD
     C                   move      w@trno        TRNO
                                                                                              CTI004
      ** IF CTI004 is installed, check message type                                           CTI004
                                                                                              CTI004
     C                   IF        CTI004 =  'Y'                                              CTI004
     C                   CALL      'MS6200'                                                   CTI004
     C                   PARM      MTPY          PMTPY                                        CTI004
     C                   PARM      w@msgbuf      PMSGBUF                                      CTI004
     C                   PARM      ' '           POKFLG                                       CTI004
                                                                                              CTI004
     C                   IF        POKFLG = 'Y'                                               CTI004
     C                   EVAL      IMPF = 'P'                                                 CTI004
     C                   EVAL      LSTS = 'T'                                                 CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CTI004
     C                   write     msixi2d0
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typa        : Process incoming messages of type A: 100, 200,    *
      * -------          202, 300, 320, 324, 330, 900, 910.                *
      *                  600.                                              *                  CSW212
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typa       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typa'     @STK(Q)
      *
      ** No field :25:
     C                   clear                   FD25
      *
      ** If message is post-1997 MT300 extract value date from field :30V:
      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)
      ** As above for post-2000 MT320, MT330                                                  184013
      ** As above for MT360, MT361, MT362                                                     184427
     C     MTPY          ifeq      '300'
     C     MTPY          oreq      '320'                                                      184013
     C     MTPY          oreq      '330'                                                      184013
     C     MTPY          oreq      '360'                                                      184427
     C     MTPY          oreq      '361'                                                      184427
     C     MTPY          oreq      '362'                                                      184427
     C     ':30V:'       scan      w@msgbuf      w@1                      83
     C                   endif
      *                                                                                       184427
      ** If message is MT340 or MT341 extract value date from field :30F:                     184427
      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        184427
     C     MTPY          ifeq      '340'                                                      184427
     C     MTPY          oreq      '341'                                                      184427
     C     ':30F:'       scan      w@msgbuf      w@1                      83                  184427
     C                   endif                                                                184427
      *
     C     MTPY          ifeq      '300'
     C     *in83         andeq     *on
     C     MTPY          oreq      '320'                                                      184013
     C     *in83         andeq     *on                                                        184013
     C     MTPY          oreq      '330'                                                      184013
     C     *in83         andeq     *on                                                        184013
     C     MTPY          oreq      '340'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '341'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '360'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '361'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C     MTPY          oreq      '362'                                                      184427
     C     *in83         andeq     *on                                                        184427
     C                   add       7             w@1
     C     6             subst     w@msgbuf:w@1  SVDT
     C     MTPY          ifeq      '362'                                                      184427
     C     ':32M:'       scan      w@msgbuf      w@1                                          184427
     C                   else                                                                 184427
     C     ':32B:'       scan      w@msgbuf      w@1
     C                   end                                                                  184427
     C                   add       5             w@1
     C                   else
                                                                                              CSW212
     C     MTPY          ifeq      '600'                                                      CSW212
     C                   movel     ':34'         w@stag                                       CSW212
     C                   else                                                                 CSW212
      *
      ** If not post-1997 MT300 find field :32a: for value date/ccy/amount
     C*****':32'******** scan      w@msgbuf      w@1                                          125554
     C                   movel     ':32'         w@stag                                       125554
     C                   endif                                                                CSW212
     C     w@scan        scan      w@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
      *
     C                   add       5             w@1
     C     6             subst     w@msgbuf:w@1  SVDT
     C                   add       6             w@1
      *
     C                   endif
      *                                                                                     AR976772
      ** Extract value date century                                                         AR976772
      *                                                                                     AR976772
     C     2             subst     SVDT:1        w@vdyy            2                        AR976772
     C     w@vdyy        iflt      '72'                                                     AR976772
     C                   movel     '20'          SVDTC                                      AR976772
     C                   else                                                               AR976772
     C                   movel     '19'          SVDTC                                      AR976772
     C                   endif                                                              AR976772
      *
      ** Extract currency
     C     3             subst     w@msgbuf:w@1  CCY
      *
      ** Extract amount
     C                   clear                   AMTS
     C                   add       3             w@1
     C     w@crlf        scan      w@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     w@msgbuf:w@1  AMTS
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typb        : Process incoming messages of type B: 201, 203.    *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typb       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typb'     @STK(Q)
      *
      ** No field :25:
     C                   clear                   FD25
      *
      ** Find field :19: and extract amount
     C*****':19'******** scan      w@msgbuf      w@1                                          125554
     C                   movel     ':19'         w@stag                                       125554
     C     w@scan        scan      w@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   clear                   AMTS
     C                   add       4             w@1
     C     w@crlf        scan      w@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     w@msgbuf:w@1  AMTS
      *
      ** Find field :30: and extract value date
     C*****':30'******** scan      w@msgbuf      w@1                                          125554
     C                   movel     ':30'         w@stag                                       125554
     C     w@scan        scan      w@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   add       4             w@1
     C     6             subst     w@msgbuf:w@1  SVDT
      *
      ** Find field :32: and extract currency
     C*****':32'******** scan      w@msgbuf      w@1                                          125554
     C                   movel     ':32'         w@stag                                       125554
     C     w@scan        scan      w@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   add       4             w@1
     C     3             subst     w@msgbuf:w@1  CCY
      *                                                                                     AR976772
      ** Extract value date century                                                         AR976772
      *                                                                                     AR976772
     C     2             subst     SVDT:1        w@vdyy                                     AR976772
     C     w@vdyy        iflt      '72'                                                     AR976772
     C                   movel     '20'          SVDTC                                      AR976772
     C                   else                                                               AR976772
     C                   movel     '19'          SVDTC                                      AR976772
     C                   endif                                                              AR976772
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typc        : Process incoming messages of type C: 950, 940.    *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typc       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typc'     @STK(Q)
      *
      ** Find field :25: and extract account details
     C                   clear                   FD25
     C*****':25'******** scan      w@msgbuf      w@1                                          125554
     C                   movel     ':25'         w@stag                                       125554
     C     w@scan        scan      w@msgbuf      w@1                                          125554
     C                   add       2             w@1                                          125554
     C*                                                                                       125554
     C                   clear                   AMTS
     C                   add       4             w@1
     C     w@crlf        scan      w@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     w@msgbuf:w@1  FD25
      *
      ** Clear remaining details
     C                   clear                   SVDT
     C                   clear                   AMTS
     C                   clear                   CCY
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************
      * sr_typd        : Process incoming messages of type D: 350.         *
      * -------                                                            *
      *                                                                    *
      * Called by      : sr_ix                                             *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_typd       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_typd'     @STK(Q)
      *
      ** No field :25:
     C                   clear                   FD25
      *
      ** Extract value date from field :30V:                                                  184013
      ** (Date is CCYYMMDD format; use offset of 7 to extract YYMMDD.)                        184013
      *                                                                                       184013
     C     ':30V:'       scan      w@msgbuf      w@1                      83                  184013
      *                                                                                       184013
     C     *in83         ifeq      *on                                                        184013
     C                   add       7             w@1                                          184013
     C     6             subst     w@msgbuf:w@1  SVDT                                         184013
     C     ':34B:'       scan      w@msgbuf      w@1                                          184013
     C                   add       5             w@1                                          184013
     C                   else                                                                 184013
      ** Find field :34P:
     C*****':34'******** scan      w@msgbuf      w@1                                          125554
     C                   movel     ':34'         w@stag                                       125554
     C*****w@scan********scan      w@msgbuf:w@1  w@1                                    125554186477
     C     w@scan        scan      w@msgbuf      w@1                                          186477
     C                   add       2             w@1                                          125554
      *
      ** Extract value date
     C                   add       5             w@1
     C     6             subst     w@msgbuf:w@1  SVDT
      *
      ** Extract currency
     C                   add       6             w@1
     C                   endif                                                                184013
     C     3             subst     w@msgbuf:w@1  CCY
      *
      ** Extract amount
     C                   clear                   AMTS
     C                   add       3             w@1
     C     w@crlf        scan      w@msgbuf:w@1  w@2
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst     w@msgbuf:w@1  AMTS
      *                                                                                     AR976772
      ** Extract value date century                                                         AR976772
      *                                                                                     AR976772
     C     2             subst     SVDT:1        w@vdyy                                     AR976772
     C     w@vdyy        iflt      '72'                                                     AR976772
     C                   movel     '20'          SVDTC                                      AR976772
     C                   else                                                               AR976772
     C                   movel     '19'          SVDTC                                      AR976772
     C                   endif                                                              AR976772
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      **********************************************************************                  CSW212
      * sr_type        : Process incoming messages of type E: 370.         *                  CSW212
      * -------                                                            *                  CSW212
      *                                                                    *                  CSW212
      * Called by      : sr_ix                                             *                  CSW212
      * Calls          : None                                              *                  CSW212
      *                                                                    *                  CSW212
      **********************************************************************                  CSW212
                                                                                              CSW212
     C     sr_type       begsr                                                                CSW212
                                                                                              CSW212
     C                   add       1             Q                                            CSW212
     C                   movel     'sr_type'     @STK(Q)                                      CSW212
                                                                                              CSW212
      ** Check for field :19A:                                                                CSW212
                                                                                              CSW212
     C     MTPY          lookup    tabty2        tabamc                   82                  CSW212
                                                                                              CSW212
     C     *in82         ifeq      *on                                                        CSW212
     C     tabamc        scan      w@msgbuf      w@1                      83                  CSW212
     C                   else                                                                 CSW212
     C     ':19A:'       scan      w@msgbuf      w@1                      83                  CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
      ** Extract Currency and Amount                                                          CSW212
                                                                                              CSW212
     C     *in83         ifeq      *on                                                        CSW212
     C                   add       12            w@1                                          CSW212
     C                   z-add     0             t@1               7 0                        CSW212
     C     w@1           add       3             t@1                                          CSW212
     C                   movel     *BLANKS       w@testn           1                          CSW212
     C                   subst     w@msgbuf:t@1  w@testn                                      CSW212
     C     digits        check     w@testn                                84                  CSW212
     C     *in84         ifeq      *on                                                        CSW212
     C                   add       1             w@1                                          CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
     C     3             subst     w@msgbuf:w@1  CCY                                          CSW212
     C                   add       3             w@1                                          CSW212
                                                                                              CSW212
     C                   clear                   AMTS                                         CSW212
     C     w@crlf        scan      w@msgbuf:w@1  w@2                                          CSW212
     C     w@2           sub       w@1           w@ln                                         CSW212
     C     w@ln          subst     w@msgbuf:w@1  AMTS                                         CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
      ** Check for field :98A:                                                                CSW212
                                                                                              CSW212
     C     MTPY          LOOKUP    tabty3        tabdat                   82                  CSW212
                                                                                              CSW212
     C     *in82         ifeq      *on                                                        CSW212
     C     tabdat        scan      w@msgbuf      w@1                      83                  CSW212
     C                   else                                                                 CSW212
     C     ':98A:'       scan      w@msgbuf      w@1                      83                  CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
      ** Extract Value date                                                                   CSW212
                                                                                              CSW212
     C     *in83         ifeq      *on                                                        CSW212
     C                   add       12            w@1                                          CSW212
     C     2             subst     w@msgbuf:w@1  SVDTC                                        CSW212
     C                   add       2             w@1                                          CSW212
     C     6             subst     w@msgbuf:w@1  SVDT                                         CSW212
     C                   endif                                                                CSW212
                                                                                              CSW212
     C                   clear                   FD25                                         CSW212
                                                                                              CSW212
     C                   clear                   @STK(Q)                                      CSW212
     C                   sub       1             Q                                            CSW212
     C                   endsr                                                                CSW212
      **********************************************************************                  CSW212
      /EJECT                                                                                  CSW212
      **********************************************************************
      * sr_rpt         : Process Report (ACK / NAK)                        *
      * ------                                                             *
      *                                                                    *
      * Called by      : sr_detail                                         *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_rpt        begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_rpt'      @STK(Q)
      *
      ** Clear message data file format
     C                   clear                   msmsi2d0
      *
      ** Access reference record for this message using TRN from field :20:
      ** if found
     C     ':20:'        scan      w@msgbuf      w@1                      78
     C     *in78         ifeq      *on
      *
     C     w@crlf        scan      w@msgbuf:w@1  w@2
     C                   add       4             w@1
     C     w@2           sub       w@1           w@ln
     C     w@ln          subst(p)  w@msgbuf:w@1  w@trno
     C     w@trno        chain     mgorefd0                           70
     C     *in70         ifeq      *off
     C     TRNF          andne     *blanks
     C     TRNF          chain     mgorefd0                           70
     C                   endif
      *
      ** If MT580 TRNO found in incoming msg tag :20: is not equal to TRNO in                 185771
      ** MGOREFPD file.                                                                       185771
     C                   movel(p)  w@trno        @mod              2                          185771
     C     *in70         ifeq      *on                                                        185771
     C     @mod          andeq     'SE'                                                       185771
     C                   movel(p)  w@trno        MFLD                                         185771
     C     MFLD          chain     MGOMSGLD                           70                      185771
     C     *in70         ifeq      *off                                                       185771
     C                   movel     TRNO          w@trno                                       185771
     C     w@trno        chain     mgorefd0                           70                      185771
     C                   endif                                                                185771
     C                   endif                                                                185771
      *                                                                                       185771
      * Add processing for block 3 if no match                        *         187213
      *                                                               *         187213
     C     *in70         ifeq      *on                                          187213
      *                                                               *         187213
      ** Access reference record for this message using TRN from field*:20:     187213
      ** if found                                                     *         187213
     C     '{108:'       scan      w@msgbuf      w@1                      78    187213
     C     *in78         ifeq      *on                                          187213
      *                                                               *         187213
     C     '}'           scan      w@msgbuf:w@1  w@2                            187213
     C                   add       5             w@1                            187213
     C     w@2           sub       w@1           w@ln                           187213
     C     w@ln          subst(p)  w@msgbuf:w@1  w@trno                         187213
     C     w@trno        chain     mgorefd0                           70        187213
     C     *in70         ifeq      *off                                         187213
     C     TRNF          andne     *blanks                                      187213
     C     TRNF          chain     mgorefd0                           70        187213
     C                   dump                                                   187213
     C                   endif                                                  187213
      *                                                                         187213
     C                   endif                                                  187213
     C                   endif                                                  187213
      *                                                               *         187213
      *****************************************************************         187213
      *
      ** If original message still exists, write ACK / NAK details
     C     *in70         ifeq      *off
      *
      ** Find the ACK / NAK date and time in field {177:YYMMDDHHMM}
     C     '{177:'       scan      w@msgbuf      w@1
     C                   add       5             w@1
     C     6             subst     w@msgbuf:w@1  w@mode
     C                   movel     w@mode        MODE
     C                   add       6             w@1
     C     4             subst     w@msgbuf:w@1  w@motm
     C                   movel     w@motm        MOTM
      *                                                                                       146340
      ** Set up Century field                                                                 146340
     C                   movel     MODE          cent                                         146340
     C     cent          iflt      '72'                                                       146340
     C                   move      '20'          MODEC                                        146340
     C                   else                                                                 146340
     C                   move      '19'          MODEC                                        146340
     C                   endif                                                                146340
      *
      ** Set up last action date and time and MIR
     C                   movel(p)  w@day         LADT
     C     w@month       lookup    tabmonn       tabmona                  77
     C     LADT          cat       tabmona:0     LADT
     C     LADT          cat       w@year:0      LADT
     C                   z-add     w@latm        LATM
      *
     C     22            subst     w@msgbuf:7    w@an_mir         22
     C                   movel(p)  MODE          MIR
     C     MIR           cat       w@an_mir:0    MIR
      *
      ** Find the Accept-Reject code in field {451:n}, and set up data
      ** and reference fields accordingly
     C     '{451:'       scan      w@msgbuf      w@1
     C                   add       5             w@1
     C     1             subst     w@msgbuf:w@1  w@acknak          1
     C     w@acknak      ifeq      '0'
     C                   move      'A'           ACNK
     C                   move      '3'           MGSG
     C                   move      'LACK'        MGST
     C                   clear                   MSE1
     C                   clear                   ELIN
     C                   else
     C                   move      'N'           ACNK
     C                   move      '4'           MGSG
     C                   move      'NACK'        MGST
      *
      ** If this is a NAK, extract the error code details
     C     '{405:'       scan      w@msgbuf      w@1
     C                   add       5             w@1
     C     3             subst     w@msgbuf:w@1  MSE1
     C                   add       3             w@1
     C     3             subst     w@msgbuf:w@1  ELIN
     C                   endif
      *
      ** Output 1st record of ACK / NAK to MSMSI2PD and update
      ** reference
     C                   movel     w@msgbuf      MDTA
     C                   write     msmsi2d0
     C                   update    mgorefd0
      *
      ** Commit transaction : (N)ACK data + reference file update
     C                   commit
      *
     C                   endif
     C                   endif
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
     C/COPY WNCPYSRC,MS3260C003
      **********************************************************************
      * sr_init        : Initialise program                                *
      * -------                                                            *
      *                                                                    *
      * Called by      : Mainline                                          *
      *                                                                    *
      * Calls          : -                                                 *
      *                                                                    *
      **********************************************************************
      *
     C     sr_init       begsr
      *
      ** Push subroutine
     C                   add       1             Q
     C                   movel     'sr_init'     @STK(Q)
      *
      ** Initialise message buffer
     C                   clear                   w@msgbuf1
      *
      ** Access bank details
     C                   call      'AOBANKR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdbank        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOBANKR0'    w0file
     C                   movel     'Bank details'w0key
     C                   z-add     01            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ** Access Message Generation/Message Management ICD
     C                   call      'AOMGMER1'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdmgme        parm      *blanks       dssdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOMGMER1'    w0file
     C                   movel     'MG/ME ICD'   w0key
     C                   z-add     02            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
      *
      ** Build arrays of SWIFT BIC+branch details v Midas branch code for
      ** use when assigning Midas branch to incoming messages (in sr_ix).
     C                   z-add     1             w@b               5 0
     C     *loval        setll     sdbrchl0
     C                   read      sdbrchl0                               50
     C     *in50         doweq     *off
     C*****w@b**         andle     99                                                         252317
     C     w@b           andle     999                                                        252317
     C                   movel     A8BRCD        br@midas(w@b)
     C                   movel(p)  w@brad        br@swift(w@b)
     C                   move      w@brbr        br@swift(w@b)
      ** Set default branch to be that of bank's internal customer                            252317
     C                   if        BJCUST = A8BICN                                            252317
     C                   movel     A8BRCD        dftbrch           3                          252317
     C                   end                                                                  252317
     C                   read      sdbrchl0                               50
     C                   add       1             w@b
     C                   enddo
      *
      ** Get module details (to check for AutoRecs II)
     C                   call      'AOMMODR0'
     C                   parm      *blanks       p@rtcd            7
     C                   parm      '*FIRST'      p@optn            7
     C     sdmmod        parm      *blanks       dsfdy
      *
      ** If the Access Object returns an error code, database error
     C     p@rtcd        ifne      *blank
     C                   movel     'AOMMODR0'    w0file
     C                   movel(p)  'modules'     w0key
     C                   z-add     03            w0ernb
     C                   movel     'MEM5003'     w0msgd
     C                   movel     'MIDAS  '     w0msgf
     C                   exsr      srerr
     C                   endif
     C/COPY WNCPYSRC,MS3260C004
                                                                                              CTI004
     C                   CALL      'AOSARDR0'                                                 CTI004
     C                   PARM      *BLANKS       PRTCD                                        CTI004
     C                   PARM      '*VERIFY'     POPTN                                        CTI004
     C                   PARM      'CTI004'      PSARD                                        CTI004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CTI004
                                                                                              CTI004
     C                   IF        PRTCD = *BLANKS                                            CTI004
     C                   EVAL      CTI004 = 'Y'                                               CTI004
     C                   ELSE                                                                 CTI004
     C                   EVAL      CTI004 = 'N'                                               CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CTI004
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   call      'SWIF2009'                                                 CSW209
     C                   parm                    p@rtcd                                       CSW209
      *                                                                                       CSW209
     C     p@rtcd        ifeq      'CSW2009'                                                  CSW209
     C                   eval      csw209 = 'Y'                                               CSW209
     C                   else                                                                 CSW209
     C                   eval      csw209 = 'N'                                               CSW209
     C                   endif                                                                CSW209
      *                                                                                       CSW209
     C
                                                                                              CMS001
      ** Check if CMS001 is installed.                                                        CMS001
                                                                                              CMS001
     C                   CALL      'AOSARDR0'                                                 CMS001
     C                   PARM      *BLANKS       PRTCD                                        CMS001
     C                   PARM      '*VERIFY'     POPTN                                        CMS001
     C                   PARM      'CMS001'      PSARD                                        CMS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMS001
                                                                                              CMS001
     C                   IF        PRTCD = *BLANKS                                            CMS001
     C                   EVAL      CMS001 = 'Y'                                               CMS001
     C                   ELSE                                                                 CMS001
     C                   EVAL      CMS001 = 'N'                                               CMS001
     C                   ENDIF                                                                CMS001
                                                                                              CMS001
      * Clear all the AOSVALR0 input parameters                                               CMS001
                                                                                              CMS001
     C     CMS001        IFEQ      'Y'                                                        CMS001
     C                   CLEAR                   SVALK1                                       CMS001
     C                   CLEAR                   SVALK2                                       CMS001
     C                   CLEAR                   SVALK3                                       CMS001
     C                   CLEAR                   SVALK4                                       CMS001
     C                   CLEAR                   SVALK5                                       CMS001
     C                   CLEAR                   SVALK6                                       CMS001
     C                   CLEAR                   SVALK7                                       CMS001
     C                   CLEAR                   SVALK8                                       CMS001
     C                   CLEAR                   SVALK9                                       CMS001
     C                   CLEAR                   SVALK0                                       CMS001
                                                                                              CMS001
      * Initialise the first system value key                                                 CMS001
                                                                                              CMS001
     C                   EVAL      SVALK1 = 'IncomingMsgDftBranch'                            CMS001
                                                                                              CMS001
      * Retrieve the system value                                                             CMS001
                                                                                              CMS001
     C                   CALL      'AOSVALR0'                                                 CMS001
     C                   PARM                    RTNCDE            7                          CMS001
     C                   PARM                    SVALK1           20                          CMS001
     C                   PARM                    SVAL1           200                          CMS001
     C                   PARM                    SVALK2           20                          CMS001
     C                   PARM                    SVAL2           200                          CMS001
     C                   PARM                    SVALK3           20                          CMS001
     C                   PARM                    SVAL3           200                          CMS001
     C                   PARM                    SVALK4           20                          CMS001
     C                   PARM                    SVAL4           200                          CMS001
     C                   PARM                    SVALK5           20                          CMS001
     C                   PARM                    SVAL5           200                          CMS001
     C                   PARM                    SVALK6           20                          CMS001
     C                   PARM                    SVAL6           200                          CMS001
     C                   PARM                    SVALK7           20                          CMS001
     C                   PARM                    SVAL7           200                          CMS001
     C                   PARM                    SVALK8           20                          CMS001
     C                   PARM                    SVAL8           200                          CMS001
     C                   PARM                    SVALK9           20                          CMS001
     C                   PARM                    SVAL9           200                          CMS001
     C                   PARM                    SVALK0           20                          CMS001
     C                   PARM                    SVAL10          200                          CMS001
                                                                                              CMS001
      * If the system value is not found then issue a database error                          CMS001
                                                                                              CMS001
     C     RTNCDE        IFNE      '       '                                                  CMS001
     C     SVAL1         IFEQ      '*NRF'                                                     CMS001
     C                   EVAL      DBKEY  =  SVALK1                                           CMS001
     C                   ENDIF                                                                CMS001
     C     *LOCK         IN        LDA                                                        CMS001
     C                   EVAL      DBASE  =  003                                              CMS001
     C                   EVAL      DBFILE =  'SDSVALPD'                                       CMS001
     C                   EVAL      DBPGM  =  'MS3260'                                         CMS001
     C                   OUT       LDA                                                        CMS001
     C                   EXSR      *PSSR                                                      CMS001
     C                   ELSE                                                                 CMS001
     C                   MOVEL     SVAL1         DftBrch           3                          CMS001
     C                   ENDIF                                                                CMS001
     C                   END                                                                  CMS001
      *
      ** Pop subroutine
     C                   clear                   @STK(Q)
     C                   sub       1             Q
     C                   endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
      ********************************************************************
      /COPY MSCPYSRC,SRERRC
      *                                                                         184427
      ** tabtyp add MT340, MT341, MT360, MT361 and MT362.                       184427
**CTDATA cpy@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA tabtyp
100A
200A
201B
202A
203B
300A
320A
324A
330A
335A
350D
900A
910A
940C
950C
340A
341A
360A
361A
362A
370E                                                                                          CSW212
600A                                                                                          CSW212
**CTDATA tabmonn
01JAN
02FEB
03MAR
04APR
05MAY
06JUN
07JUL
08AUG
09SEP
10OCT
11NOV
12DEC
**CTDATA ar1
??4C<
??4F!
??50&
??5C*
??5E;
??6C%
??6D_
??6E>
??7B#
??7C@
??7E=
??7F"
??C0{
??D0}
**CTDATA tabty2                                                                               CSW212
370:19A::NETT                                                                                 CSW212
**CTDATA tabty3                                                                               CSW212
370:98A::VALU                                                                                 CSW212
