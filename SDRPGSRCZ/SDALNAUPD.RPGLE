     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Alternative Names & Addr details DB Upd.')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDALNAUPD - Customer Alternative Names & Addresses Details   *
      *              database update                                  *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
     FSDALTNL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * Midas SD Alternative Name & Address Detail Master File
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)
      * Midas SD Compliance Watch Hit List(Ftyp/Iden/Brch)
     FSDFCTLL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      * UPD : Midas SD Standing data controls update
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
      ** The following /COPY includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D ChkAlnaFmt    E DS                  EXTNAME(SDALTNPD)
     D                                     PREFIX(CH)
      ** Rename fields for Timestamp checking
 
     D SDVAlna       E DS                  EXTNAME(SDVALNAPD)
     D                                     PREFIX(A_)
      ** Externally desc'd DS for valid Alt Names & Addresses Detail
 
     D OKAlnDets     E DS                  EXTNAME(SDEALNAPD)
      ** Error indicators
 
     D B_ALNAF       E DS                  EXTNAME(SDALTNPD)
     D                                     PREFIX(B_)
      ** Externally described DS for 'BEFORE UPDATE' name & address
 
      **  Alternative Names & Addresses Details File
     D ALNAF         E DS                  EXTNAME(SDALTNPD)
      ** Data Structure for Watch List Configuration Data file
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      ** Data Structure for first parameter for the Compliance Engine
     D PDSWLT        E DS                  EXTNAME(SDWLTOPD)
      ** Data Structure for Watch List Checking Details
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
      ** DS for accessing enhancement file
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Short data structure used for access object
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Long data structure used for access object
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for getting the system prefix when CSC011 is not installed
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ** DS for getting the system prefix when CSC011 is installed
     D SC24X7        E DS                  EXTNAME(SC24X7)
      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data Structure for second parameter for the Compliance Engine
     D PDSXML          DS          9999
     D OPNTAG          S             35    Dim(3)  CTDATA
     D CLSTAG          S             35    Dim(3)  CTDATA
 
      * Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Data structure for bank details
 
 
      ** Dummy message ID and message file fields for use on the calls
      ** to ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * Outward parameters
      * RCD : Midas SD Deleted records file retrieval
     D PBRC            DS          3064
      * I :  File name
     D    PBFNME               1     10
      * I :  Long Key
     D    PBLKEY              11     60
      * I :  Deleted Data Record Pt1
     D    PBDR01              61    310
      * I :  Deleted Data Record Pt2
     D    PBDR02             311    560
      * I :  Deleted Data Record Pt3
     D    PBDR03             561    810
      * I :  Deleted Data Record Pt4
     D    PBDR04             811   1060
      * I :  Deleted Data Record Pt5
     D    PBDR05            1061   1310
      * I :  Deleted Data Record Pt6
     D    PBDR06            1311   1560
      * I :  Deleted Data Record Pt7
     D    PBDR07            1561   1810
      * I :  Deleted Data Record Pt8
     D    PBDR08            1811   2060
      * I :  Deleted Data Record Pt9
     D    PBDR09            2061   2310
      * I :  Deleted Data Record Pt10
     D    PBDR10            2311   2560
      * I :  Deleted Data Record Pt11
     D    PBDR11            2561   2810
      * I :  Deleted Data Record Pt12
     D    PBDR12            2811   3060
      * I :  Last Change Date
     D    PBLCD             3061   3063P 0
      * I :  Type of Last Change
     D    PBTYLC            3064   3064
 
     D WUDELR          DS          3000
     D    WUDR01               1    250
     D    WUDR02             251    500
     D    WUDR03             501    750
     D    WUDR04             751   1000
     D    WUDR05            1001   1250
     D    WUDR06            1251   1500
     D    WUDR07            1501   1750
     D    WUDR08            1751   2000
     D    WUDR09            2001   2250
     D    WUDR10            2251   2500
     D    WUDR11            2501   2750
     D    WUDR12            2751   3000
 
 
     D @Timestamp      S             26Z
 
     D WKACSN          S              2P 0
      ** Account sequence field (packed) for call to CLINTSE
 
     D @@RTCD          S              7A
 
     D*@RTCD           S              7A
     D*@OPTN           S              7A
      ** Parameters for AOBANKR0
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
      ** Parameters for AOSARDR0
 
     D PFNCCD          S              8A
      ** Parameters for AOWLCCR0
 
     D PCUST           S             10A
     D PSTKEY          S              7A
      ** Parameters for AOCUSTR0
 
     D @Return         S              6A
     D @Type           S              1A
      ** Parameters for ZARTVJOBA
 
     D CSD015          S              1A
     D CSC011          S              1A
     D CCF001          S              1A
 
     D @@MODE          S              6A
     D @@RSMD          S              1A
     D ACTN            S              1A
     D FOTRID          S             20A
     D Ix              S              3P 0
 
     D C               S              2P 0
     D DBError         S            132A
     D MsgSndRtn       S             10A
 
     D KFUNT           S              8A
     D KIDEN           S             40A
     D KBRCH           S              3A
 
     D WUNCF1          S              1A
     D WKFLNM          S             10A
     D WADDAL          S            100A
 
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program
 
     C                   EXSR      CHKOTHUPD
 
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
 
      ** Insert, Amend or Delete the transaction
 
     C     A_NATYLC      CASEQ     'I'           INSERT
     C     A_NATYLC      CASEQ     'A'           AMEND
     C     A_NATYLC      CASEQ     'D'           DELETE
     C                   ENDCS
 
      ** Exit From Program
 
     C     EXIT          TAG
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    @@RTCD
 
      ** Externally described DS for valid Alt Name & Address Detail
 
     C                   PARM                    SdVALNA
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY  = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  909
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key Lists
 
     C     KALTN         KLIST
     C                   KFLD                    A_NACUST
     C                   KFLD                    A_NAADCD
 
      ** Access SAR Details to see if Compliance Watch is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD015'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSD015'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If enhancement CSD015 is installed, access SDWLCCPD to
      ** see if 'SDCUSD' function code is available
 
     C     PRTCD         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           CSD015
 
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      'CUSTALTA'    PFNCCD
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF'
     C                   MOVEL     'CUSTALTA'    DBKEY
     C                   MOVEL     'SDWLCCPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SDCWCDPD to get the 5 'Private Customer Industry
      ** Code'
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDCWCDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Determine if enhancement CSC011 is installed
 
     C                   MOVE      'N'           CSC011
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSC011'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC011
     C     *DTAARA       DEFINE                  SC24X7
     C                   IN        SC24X7
     C                   ENDIF
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
 
      ** Access SAR Details to see if Concord Interface Development
      ** is installed
 
     C                   MOVE      'N'           CCF001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CCF001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CCF001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CCF001
     C                   ENDIF
 
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY '    POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS  AND                                      CSD083
     C                             PRTCD <> '*NRF   '                                         CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 913                                                CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return
     C                   PARM                    @Type
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHKOTHUPD - Check for update by another workstation           *
      *                                                               *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current Customer details
 
     C                   CALLB     'SDALNARTV'
 
      ** Inputs
 
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
 
     C                   PARM                    @@MODE
 
      ** Response mode
 
     C                   PARM      ' '           @@RSMD
 
      ** Action Code
 
     C                   PARM      A_NATYLC      ACTN
 
      ** Front Office Transaction ID
 
     C                   PARM      A_NAFRNT      FOTRID
 
      ** Midas Customer Number & Address Code
 
     C                   PARM                    A_NACUST
     C                   PARM                    A_NAADCD
 
      ** Outputs
 
      ** Alternative Names & Addresses Details in File Format
     C                   PARM                    ChkAlnaFmt
 
      ** OK - Action code
 
     C                   PARM      *BLANK        DDACTNOK
 
      ** OK - Customer Number
 
     C                   PARM                    DDCUSTOK
      ** OK - Address Code
 
     C                   PARM                    DDADCDOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Ix
 
      ** Error if Timestamp is not the same (record has been changed
      ** by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Customer was fetched
      ** by this program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
 
     C                   IF        @TYPE = '1'
 
     C                   IF        CHBCTMST <> A_NATMST
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
 
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDCUSTOK = 'N' OR
     C                             DDADCDOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C
 
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INSERT - Insert a transaction                                 *
      *                                                               *
      *****************************************************************
     C     INSERT        BEGSR
 
      ** Access Alternative Names & Addresses Details
 
     C     KALTN         CHAIN     SDALTNL0                           99
 
      ** Database error
 
     C                   IF        *IN99 = *OFF
     C                   EVAL      DBKEY  = A_NACUST
     C                   EVAL      DBFILE = 'SDALTNPD'
     C                   EVAL      DBASE  =  905
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Alternative Names & Addresses Detail
 
     C                   CLEAR                   ALNAF
 
      ** Store Old fields for comparisons
 
     C                   MOVEL(P)  ALNAF         B_ALNAF
 
      ** SET Alternative Names & Addresses FIELDS ON INSERT
 
     C                   MOVEL     A_NACUST      BCCUST
     C                   MOVEL     A_NAADCD      BCADCD
     C                   MOVEL     A_NACNA1      BCCNA1
     C                   MOVEL     A_NACNA2      BCCNA2
     C                   MOVEL     A_NACNA3      BCCNA3
     C                   MOVEL     A_NACNA4      BCCNA4
     C                   MOVEL     A_NACRTN      BCCRTN
     C                   MOVEL     A_NACTNB      BCCTNB
     C                   MOVEL     A_NATXNB      BCTXNB
     C                   MOVEL     A_NACNCD      BCCNCD
     C                   MOVEL     A_NALCD       BCLCD
     C                   MOVEL     A_NATYLC      BCTYLC
     C                   MOVEL     A_NAFRNT      BCFRNT
 
      ** Timestamp
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      BCTMST  = TimeStamp
 
      ** If watch list checking is applied
 
     C     CSD015        IFEQ      'Y'
     C     W1EWLC        ANDEQ     'Y'
 
      ** If user is in the main system
 
     C     CSC011        IFEQ      'N'
     C     CSC011        OREQ      'Y'
     C     S1MAIN        ANDEQ     LIBR
 
      ** If any of the watch list fields have been entered
 
     C     A_NACNA1      IFNE      *BLANKS
     C     A_NACNA2      ORNE      *BLANKS
     C     A_NACNA3      ORNE      *BLANKS
     C     A_NACNA4      ORNE      *BLANKS
     C     A_NACNCD      ORNE      *BLANKS
 
     C                   EXSR      SRWTCH
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Write new Alternative Names & Addresses Detail
 
     C                   WRITE     @BCREDD
 
      ** UPDATE SD STANDING DATA CONTROL FILE
 
     C                   EXSR      UPDCTRL
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AMEND  - Amend a transaction                                  *
      *                                                               *
      *****************************************************************
     C     AMEND         BEGSR
 
      ** Access Alternative Names & Addresses Details
 
     C     KALTN         CHAIN     SDALTNL0                           9998
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_NACUST
     C                   EVAL      DBFILE = 'SDALTNPD'
     C                   EVAL      DBASE  =  906
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked
 
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_NACUST
     C                   EVAL      DBFILE = 'SDALTNPD'
     C                   EVAL      DBASE  =  907
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  ALNAF         B_ALNAF
 
      ** SET Alternative Names & Addresses FIELDS ON AMEND
 
     C                   MOVEL     A_NACUST      BCCUST
     C                   MOVEL     A_NAADCD      BCADCD
     C                   MOVEL     A_NACNA1      BCCNA1
     C                   MOVEL     A_NACNA2      BCCNA2
     C                   MOVEL     A_NACNA3      BCCNA3
     C                   MOVEL     A_NACNA4      BCCNA4
     C                   MOVEL     A_NACRTN      BCCRTN
     C                   MOVEL     A_NACTNB      BCCTNB
     C                   MOVEL     A_NATXNB      BCTXNB
     C                   MOVEL     A_NACNCD      BCCNCD
     C                   MOVEL     A_NALCD       BCLCD
     C                   MOVEL     A_NATYLC      BCTYLC
     C                   MOVEL     A_NAFRNT      BCFRNT
 
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   EVAL      BCTMST  = TimeStamp
 
 
 
      ** If watch list checking is applied
 
     C     CSD015        IFEQ      'Y'
     C     W1EWLC        ANDEQ     'Y'
 
      ** If user is in the main system
 
     C     CSC011        IFEQ      'N'
     C     CSC011        OREQ      'Y'
     C     S1MAIN        ANDEQ     LIBR
 
      ** Access customer details file for Branch Code
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      BCCUST        PCUST
     C                   PARM      *BLANKS       PSTKEY
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     BCCUST        DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '908'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SDCWHTPD to determine Hit Unconfirmed Flag
 
     C     KCWHTL        KLIST
     C                   KFLD                    KFUNT
     C                   KFLD                    KIDEN
     C                   KFLD                    KBRCH
 
     C                   MOVEL     'SDALTNPD'    KFUNT
     C                   MOVE      *BLANKS       KIDEN
     C                   CAT       BCCUST:0      KIDEN
     C                   CAT       BCADCD:0      KIDEN
     C                   MOVEL     BBBRCD        KBRCH
 
     C     KCWHTL        CHAIN     SDCWHTL1                           06
     C     *IN06         IFEQ      '1'
     C                   MOVE      *BLANKS       WUNCF1
     C                   ELSE
     C     W3UNCF        IFEQ      'Y'
     C                   MOVE      'Y'           WUNCF1
     C                   ENDIF
     C                   ENDIF
 
      ** If any of the watch list fields has been entered or W3UNCF = '
 
     C     B_BCCNA1      IFNE      BCCNA1
     C     B_BCCNA2      ORNE      BCCNA2
     C     B_BCCNA3      ORNE      BCCNA3
     C     B_BCCNA4      ORNE      BCCNA4
     C     B_BCCNCD      ORNE      BCCNCD
     C     WUNCF1        OREQ      'Y'
 
     C                   EXSR      SRWTCH
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Update Alternative Names & Addresses Record
 
     C                   UPDATE    @BCREDD
 
      ** UPDATE SD STANDING DATA CONTROL FILE
 
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DELETE - Delete a transaction                                 *
      *                                                               *
      *****************************************************************
     C     DELETE        BEGSR
 
      ** Access Alternative Names & Addresses Details
 
     C     KALTN         CHAIN     SDALTNL0                           9998
 
      ** Database error
 
     C                   IF        *IN99 = *ON
     C                   EVAL      DBKEY  = A_NACUST
     C                   EVAL      DBFILE = 'SDALTNPD'
     C                   EVAL      DBASE  =  909
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Record Locked
 
     C                   IF        *IN98 = *ON
     C                   EVAL      DBKEY  = A_NACUST
     C                   EVAL      DBFILE = 'SDALTNPD'
     C                   EVAL      DBASE  =  910
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update 'BEFORE' status
 
     C                   MOVEL(P)  ALNAF         B_ALNAF
 
      ** Delete record
 
     C                   DELETE    @BCREDD
 
      ** UPDATE SD STANDING DATA CONTROL FILE
 
     C                   EXSR      UPDCTRL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* UPDCTRL - UPDATE STANDING DATA CONTROL FILE                   *
     C*                                                               *
     C*****************************************************************
     C     UPDCTRL       BEGSR
 
     C                   MOVE      *BLANKS       WKFLNM
     C                   MOVEL     'SDALTNPD'    WKFLNM
     C     WKFLNM        CHAIN     @AHREAU                            9899
 
      ** Record not found
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'SDALTNPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '911'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Record locked
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'SDALTNPD'    DBKEY
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     '912'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   SELECT
 
      ** Input
 
     C     A_NATYLC      WHENEQ    'I'
     C                   EVAL      AHNORC = (AHNORC + 1)
     C                   EVAL      AHNOIN = (AHNOIN + 1)
 
      ** Amend
 
     C     A_NATYLC      WHENEQ    'A'
     C                   EVAL      AHNOAM = (AHNOAM + 1)
 
      ** Delete
 
     C     A_NATYLC      WHENEQ    'D'
     C                   EVAL      AHNORC = (AHNORC - 1)
     C                   EVAL      AHNODL = (AHNODL + 1)
     C                   ENDSL
     C                   UPDATE    @AHREAU
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SRWTCH  - To call the watch list checking engine              *
     C*                                                               *
     C*****************************************************************
     C     SRWTCH        BEGSR
     C                   MOVE      *BLANKS       PDSWLT
 
      ** Move zeros to date and amount fields since they will not be us
 
     C                   Z-ADD     0             W4DDAT
     C                   Z-ADD     0             W4VDAT
     C                   Z-ADD     0             W4MDAT
     C                   Z-ADD     0             W4AMT1
     C                   Z-ADD     0             W4AMT2
     C                   MOVEL     'SDCALT'      W4ITEM
     C                   CAT       BCCUST:0      W4IDEN
     C                   CAT       BCADCD:0      W4IDEN
     C                   MOVEL     'SDALTNPD'    W4FUNT
 
      ** Get System Prefix from SC24X7 if CSC011 is installed
 
     C     CSC011        IFEQ      'Y'
     C                   MOVE      S1MAIN        W4SYSM
     C                   ELSE
 
      ** Else, get it from SDSTAT
 
     C                   MOVE      LIBR          W4SYSM
     C                   ENDIF
 
      ** Access customer details file for Counter Party
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      BCCUST        PCUST
     C                   PARM      *BLANKS       PSTKEY
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     BCCUST        DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '911'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BBCRNM        W4CUST
     C                   MOVE      BBCRTN        W4CUST
     C                   MOVE      BBCUST        W4CNUM
     C                   MOVE      BBBRCD        W4BRCH
 
      ** Get counterparty type depending on CCF001
 
     C     CCF001        IFEQ      'Y'
 
     C     BBCRPC        IFEQ      'Y'
     C                   MOVE      'C'           W4CTYP
     C                   ELSE
     C                   MOVE      'I'           W4CTYP
     C                   ENDIF
 
     C                   ELSE
 
     C     BBLICD        IFNE      *BLANKS
     C     BBLICD        ANDNE     W1IND1
     C     BBLICD        ANDNE     W1IND2
     C     BBLICD        ANDNE     W1IND3
     C     BBLICD        ANDNE     W1IND4
     C     BBLICD        ANDNE     W1IND5
     C                   MOVE      'C'           W4CTYP
     C                   ELSE
     C                   MOVE      'I'           W4CTYP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set-up second parameter (Customer Alternative Name)
 
     C                   MOVE      *BLANKS       PDSXML
     C     B_BCCNA1      IFNE      A_NACNA1
     C     WUNCF1        OREQ      'Y'
     C     BCCNA1        IFNE      *BLANKS
     C                   CAT       OPNTAG(1):0   PDSXML
     C                   CAT       BCCNA1:0      PDSXML
     C                   CAT       CLSTAG(1):0   PDSXML
     C                   ENDIF
     C                   ENDIF
 
      ** Set-up second parameter (Customer Alternative Address)
 
     C     B_BCCNA2      IFNE      A_NACNA2
     C     B_BCCNA3      ORNE      A_NACNA3
     C     B_BCCNA3      ORNE      A_NACNA4
     C     WUNCF1        OREQ      'Y'
     C                   MOVE      *BLANKS       WADDAL
     C     WADDAL        CAT       BCCNA2:0      WADDAL
     C     WADDAL        CAT       BCCNA3:1      WADDAL
     C     WADDAL        CAT       BCCNA4:1      WADDAL
     C     WADDAL        IFNE      *BLANKS
     C                   CAT       OPNTAG(2):0   PDSXML
     C                   CAT       WADDAL:0      PDSXML
     C                   CAT       CLSTAG(2):0   PDSXML
     C                   ENDIF
     C                   ENDIF
 
      ** Set-up second parameter (Country of Domicile)
 
     C     B_BCCNCD      IFNE      A_NACNCD
     C     WUNCF1        OREQ      'Y'
     C     BCCNCD        IFNE      *BLANKS
     C                   CAT       OPNTAG(3):0   PDSXML
     C                   CAT       BCCNCD:0      PDSXML
     C                   CAT       CLSTAG(3):0   PDSXML
     C                   ENDIF
     C                   ENDIF
 
      ** Call Watch List Engine Program
 
     C     PDSXML        IFNE      *BLANKS
     C                   CALL      'SDWLCLOP'
     C                   PARM                    PDSWLT
     C                   PARM                    PDSXML
     C                   ENDIF
 
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
     C/COPY ZACPYSRC,PSSR_ILE
 
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2006
** OPNTAG
<Customer Alternative Name>
<Customer Alternative Addr>
<Country of Domicile>
** CLSTAG
</Customer Alternative Name>
</Customer Alternative Addr>
</Country of Domicile>
