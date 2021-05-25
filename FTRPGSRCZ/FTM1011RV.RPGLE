     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT header retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTM1011RV - Request for Transfer Payments - Header Retrieve  *
      *                                                               *
      *  Function:  This module retrieves a debit record from Midas   *
      *             database.                                         *
      *  Depending the input parameters it can return :-              *
      *  a debit record format                                        *
      *  a MT101 sequence A format                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR928996A          Date 03May12               *
      *  Prev Amend No. AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7029            Date 09Jun05               *
      *                 221761             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184164             Date 31Oct00               *
      *                 185660             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *Create    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  184164 - Access FT instead of FF                             *
      *  185660 - When routing using ?,all message parts should be    *
      *         - processed                                           *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFT101HL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FMEINMRL2  IF   E           K DISK                                         185660
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
     D/COPY MECPYSRC,ME1100_ILE
      **
     D MSGREF          DS
     D REFMSG                  1      8  0
     D REFPRT                  9     11  0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D************* SQ101A          C                   CONST(-1)                    PF0002
     D SQ101A          C                   CONST(0)                                  PF0002
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Data structure for file status of FT deals file.
     D INFDS           DS
     D  RECORD           *RECORD
 
     D OkRftHdr      E DS                  EXTNAME(FTE101HBPD)
      ** EXTERNAL DS FOR OK FLAGS HEADER
 
     D DDsRftHdr     E DS                  EXTNAME(FT101HPD)
      ** EXTERNAL DS FOR RFT HEADER
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D*SDFODA******* E DS                  EXTNAME(SDFODAPD)                    184164
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)                    184164
      ** EXTERNAL DS FOR FUNDS TRANSFER ICD DETAILS
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D MREFARR         S              8    DIM(100)                             185660
      ** Message reference array                                                185660
                                                                                185660
     D MPRTARR         S              3    DIM(100)                             185660
      ** Message part array                                                     185660
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              2  0                                      PF0001
 
      ** Index for arrays of msg ref and part                                   185660
     D MX              S              2  0                                      185660
                                                                                185660
      ** Message reference (input parameter)
     D MGMSGR          S                   LIKE(PHMSGR)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      **  GET ZMUSER to access default branch.                                               BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029
      *
      ** Validate Action Code & RFT ID
      *
      *
     C                   Clear                   DdsRftHdr
     C                   Clear                   PDATA
     C                   CLEAR                   PDAT2                                        CSW209
     C                   Movel     *ALL'Y'       OkRftHdr
     C                   Z-add     0             Ix
     C                   Movel     *BLANK        FldNameArr
     C                   Movel     *BLANK        MsgIdArr
     C                   Movel     *BLANK        MsgDtaArr
     C                   Movel     *BLANK        RetCodeIn
     C                   CLEAR                   MREFARR                        185660
     C                   CLEAR                   MREFARR                        185660
     C                   Z-ADD     0             MX                             185660
 
 
      ** Particular case, where if message key is entered we will return
      ** a RFT message format
     C                   If        MGMSGR <> 0
     C                   Move      MGMSGR        PHMSGR
     C                   Z-add     SQ101A        PHPART
 
      ** Retrieve contents of the message
     C     Ix            Ifeq      0
     C                   Exsr      RTVMSG
     C                   Endif
 
      ** Translate existing tag values
     C     Ix            Ifeq      0
     C                   Exsr      TRNTAG
     C                   Endif
 
     C                   Goto      ExRtv
     C                   Endif
 
      ** Others cases, a RFT record format is returned
      *
     C                   If        RFTIDO<> *blanks
     C     RFTIDO        Chain     FT101HL3                           90
     C                   If        *IN90 = '1'
     C                   Movel     'RFTIDO '     DBKEY
     C                   Movel     '001'         DBASE
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** If action is not 'I' then must move rft type into parameter list
     C                   EVAL      @RftTyp = PYTP
      *
     C                   Endif
      *
      ** Hearder retrieve => we pick up contents of the sequence A of
      ** MT101
     C                   Z-add     SQ101A        @KPRT
     C                   Z-add     SQ101A        PHPART
      *
     C                   Movel     SWIFTR        SSWTN            28
      *
     C                   If        SSWTN <> *Blanks
     C                             and ACTN = 'I'
      *
      *
      *  The swift reference may hold either a '?' or an actual swift
      *  reference. The called program will determine which.
      *
     C                   Call      'ME1080'                             90
     C                   Parm      '*KEY'        @ACT              7
     C     PHMSGR        Parm      *ZEROS        @MSGR             8 0
     C                   Parm                    @KPRT             3 0
     C                   Parm      SSWTN         @MOR             28
     C     SWIFTR        Parm      SSWTN         @MIR             28
     C                   Parm      *BLANKS       @RTN              7
      *
      * If '?' was entered
      * ------------------
      *
      * If MIN0105 - Reserved message found
      *
      * If there is an electronic message for the current job then
      * prepare input fields for processing
      *
     C                   Select
      *
      * If call to program resulted in an error then end program
      *
     C                   When      @RTN = '*ERROR*' or *IN90
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     SSWTN         DBKEY
     C                   Movel     'ME1080  '    DBFILE
     C                   Movel     '002'         DBASE
     C                   Exsr      *PSSR
      *
      *  F3 pressed - exit program
      *
     C                   When      @RTN = 'Y2U9999'
     C                   Move      '03'          @KeyP
     C                   Goto      ExRtv
      *
      *  F12 pressed - exit program
      *
     C                   When      @RTN = 'USR0790'
     C                   Move      '12'          @KeyP
     C                   Goto      ExRtv
      *
      * Messages that are selected using the '?' facility are reserved
      * at time of selection.
      *
      * Reserved message found
     C                   When      @RTN = 'MIN0105'
      *
      * Message already reserved for this job
     C                   When      @RTN = 'MIN0103'
      *
     C
      *
      * Valid message selected not reserved yet
     C                   When      @RTN = 'MIN0112'
     C                   Call      'ME1070'                             90
     C                   Parm      '*RESERV'     @ACT              7
     C                   Parm                    @MSGR
     C                   Parm                    @KPRT
     C                   Parm                    @MOR
     C                   Parm                    @MIR
     C                   Parm      *Blanks       @RTN
      *
     C                   If        *IN90
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'ME1070'      DBFILE
     C                   Movel     '*CALL'       DBKEY
     C                   Movel     '003'         DBASE
     C                   Exsr      *PSSR
     C                   Movel     *BLANKS       SSWTN
     C                   Endif
      *
     C                   If        @RTN <> 'MIN0109'
     C                   Movel     'N'           OKSWFRF
     C                   Add       1             Ix
     C                   Movel     'ME1070'      FldNameArr(Ix)
     C                   Movel     @RTN          MsgIdArr(Ix)
     C                   Movel     @RTN          RetCodeIn
     C                   Goto      ExRtv
     C                   Endif
      *
     C                   Other
     C                   Movel     'N'           OKSWFRF
     C                   Add       1             Ix
     C                   Movel     'ME1080'      FldNameArr(Ix)
     C                   Movel     @RTN          MsgIdArr(Ix)
     C                   Movel     @RTN          RetCodeIn
     C                   Goto      ExRtv
     C                   Endsl
 
      ** Load message ref and part array from MEINMRPD so detail                185660
      ** records can be processed later                                         185660
                                                                                185660
     C     KMEINMRPD     KLIST                                                  185660
     C                   KFLD                    PSJOBNAME                      185660
     C                   KFLD                    PSUSER                         185660
     C                   KFLD                    PSJOBNO                        185660
                                                                                185660
     C     KMEINMRPD     SETLL     MEINMRL2                                     185660
     C     KMEINMRPD     READE     MEINMRL2                               30    185660
                                                                                185660
     C                   DOW       *IN30 = *OFF                                 185660
     C                   ADD       1             MX                             185660
     C                   MOVE      MRMSGR        MREFARR(MX)                    185660
     C                   MOVE      MRKPRT        MPRTARR(MX)                    185660
     C     KMEINMRPD     READE     MEINMRL2                               30    185660
     C                   ENDDO                                                  185660
                                                                                185660
      ** Retrieve contents of the message
     C     Ix            Ifeq      0
     C                   Exsr      RTVMSG
     C                   Endif
 
      ** Translate existing tag values
     C     Ix            Ifeq      0
     C                   Exsr      TRNTAG
     C                   Endif
 
     C                   Endif
 
 
      * Return
     C     ExRtv         TAG
     C                   RETURN
 
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** RTVMSG - Retrieve message details
      *****************************************************************
     C     RTVMSG        Begsr
      *
      ** Call ME1100 to translate the data of the messages for FT fields
      *
     C                   Call      'ME1100'                             90
     C                   Parm      '*TRANS  '    #ACT              8
     C                   Parm                    PHEAD
     C                   Parm      *Blanks       PDATA
     C                   Parm      *BLANKS       PDAT2                                        CSW209
     C                   Parm      *Blanks       RTN               7
      *
     C                   If        RTN <> 'MIN0096' or *IN90
     C                   Movel     'N'           OKSWFRF
     C                   Add       1             Ix
     C                   Movel     'ME1100'      FldNameArr(Ix)
     C                   Movel     'RFR0001'     MsgIdArr(Ix)
     C                   Movel     'RFR0001'     RetCodeIn
     C                   Endif
     C
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      ** TRNTAG - Translate existing tag values
      *****************************************************************
     C     TRNTAG        Begsr
      *
      * Call ME1580 to translate the data of the messages for FT fields
      *
     C                   Call      'ME1580'                             90
     C                   Parm      '*TRANS  '    #ACT              8
     C                   Parm                    PHEAD
     C                   Parm                    PDATA
     C                   Parm                    PDAT2                                        CSW209
     C                   Parm      *BLANKS       RTN               7
     C
     C                   If        RTN <> *BLANK or *IN90
     C                   Movel     'N'           OKSWFRF
     C                   Add       1             Ix
     C                   Movel     'ME1580'      FldNameArr(Ix)
     C                   Movel     'RFR0002'     MsgIdArr(Ix)
     C                   Movel     'RFR0002'     RetCodeIn
     C                   Endif
     C
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        Begsr
 
      * Parameters
     C     *ENTRY        Plist
 
      * INPUTS
      * Return code
     C                   Parm                    RetCodeIn
      * Action Code
     C                   Parm                    ACTN              1
      * Rft type
     C                   Parm                    @RftTyp           2
      * (Midas) RFT ID
     C                   Parm                    RFTIDO           15
      * Swift reference (ALSO OUPUT)
     C                   Parm                    SWIFTR           28
      * Message unique reference (for STP)
     C                   Parm                    MGMSGR
      * RFT Header Record
     C                   Parm                    DDsRftHdr
      * Key Pressed
     C                   Parm                    @KeyP             2
      * Details of the message
     C                   Parm                    PDATA
      * Details of the message extension                                                      CSW209
     C                   Parm                    PDAT2                                        CSW209
      * Message ref array                                                       185660
     C                   PARM                    MREFARR                        185660
      * Message part array                                                      185660
     C                   PARM                    MPRTARR                        185660
 
      ** Errors produced during retrieve operation
     C                   Parm                    OkRftHdr
     C                   Parm                    Ix
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIdArr
     C                   Parm                    MsgDtaArr
 
      ** Initialize program name
 
     C                   Movel     'FTM1011RV'   DBPGM
 
      ** Access Bank Details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      * Database Error
      *
     C                   If        @RTCD <> *Blanks
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '007'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** Access General LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * Database error
      *
     C                   If        @RTCD <> *Blanks
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'SDGELRPD'    DBFILE
     C                   Movel     '008'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** Access Funds Transfer Details
     C*******************Call      'AOFODAR0'                                   184164
     C                   Call      'AOFTFRR0'                                   184164
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C*****SDFODA********Parm      SDFODA        DSFDY                          184164
     C     SDFTFR        Parm      SDFTFR        DSFDY                          184164
 
      * Database Error
     C                   If        @RTCD <> *Blanks
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     @OPTN         DBKEY
     C*******************Movel     'SDFODAPD'    DBFILE                         184164
     C                   Movel     'SDFTFRPD'    DBFILE                         184164
     C                   Movel     '009'         DBASE
     C                   Exsr      *PSSR
     C                   Endif
      **********                                                                             BUG7029
      ****GET*ZMUSER*to*access*default*branch.                                               BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
     C**********         UNLOCK    ZMUSER                                                    BUG7029
 
     C                   Callb     'ZACRTVJOBA'                         90
     C                   Parm                    PSJobName
     C                   Parm                    PSUser
     C                   Parm                    PSJobNo
     C                   Parm                    JobType           5
      *
     C     *IN90         Ifeq      '1'
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Movel     'FTM1011RV'   DBPGM
     C                   Movel     'ZACRTVJOBA'  DBFILE
     C                   Movel     '010'         DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
