     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT CCT Header details retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTM1021RV - Customer Credit Transfer - Header Retrieve       *
      *                                                               *
      *  Function:  This module retrieves a debit record from Midas   *
      *             database.                                         *
      *                                                               *
      *  Depending the input parameters it can return :-              *
      *  a header record format                                       *
      *  a MT102 sequence A format                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00               *
      *                 184164             Date 31Oct00               *
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *Create    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompile)                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185660 - When routing using ?,all message parts should be    *
      *         - processed                                           *
      *  184164 - Replace access to SDFODAPD to SDFTFRPD              *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFT102HL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     FMEINMRL2  IF   E           K DISK                                         185660
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
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
     D MsgRef          DS
     D RefMsg                  1      8  0
     D RefPrt                  9     11  0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Swift sequence number for header details
     D SQ102A          C                   CONST(0)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Data structure for file status of FT deals file.
     D INFDS           DS
     D  RECORD           *RECORD
 
     D OkCctHdB      E DS                  EXTNAME(FTE102HBPD)
      ** EXTERNAL DS FOR OK FLAGS HEADER
 
     D DDsCctHdr     E DS                  EXTNAME(FT102HPD)
      ** EXTERNAL DS FOR CCt HEADER
 
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
     D Ix              S              2  0
 
      ** Index for arrays of msg ref and part                                   185660
     D MX              S              2  0                                      185660
                                                                                185660
      ** Message reference (input parameter)
     D MgmsgR          S                   LIKE(PhmsgR)
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
      ** Initialise fields and reset errors
      *
     C                   CLEAR                   DdsCCtHdr
     C                   CLEAR                   PData
     C                   CLEAR                   PDat2                                        CSW209
     C                   MOVEL     *ALL'Y'       OkCCtHdB
     C                   Z-ADD     0             Ix
     C                   MOVEL     *BLANKS       FldNameArr
     C                   MOVEL     *BLANKS       MsgIdArr
     C                   MOVEL     *BLANKS       MsgDtaArr
     C                   MOVEL     *BLANKS       RetCodeIn
     C                   CLEAR                   MREFARR                        185660
     C                   CLEAR                   MREFARR                        185660
     C                   Z-ADD     0             MX                             185660
      *
      ** Particular case, where if message key is entered we will return
      ** a CCt message format
      *
     C                   IF        MgmsgR <> 0
     C                   MOVE      MgmsgR        PhmsgR
     C                   Z-ADD     SQ102A        Phpart
      *
      ** Retrieve contents of the message
      *
     C     Ix            IFEQ      0
     C                   EXSR      RTVMSG
     C                   ENDIF
      *
      ** Translate existing tag values
      *
     C     Ix            IFEQ      0
     C                   EXSR      TRNTAG
     C                   ENDIF
     C                   GOTO      ExRtv
     C                   ENDIF
      *
      ** Others cases, a CCt record format is returned
      *
     C                   IF        CCtIDO <> *BLANKS
     C     CCtIDO        CHAIN     FT102HL3                           90
     C                   IF        *IN90 = '1'
     C                   MOVEL     'CCtIDO '     Dbkey
     C                   MOVEL     '001'         Dbase
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If CCtID is not BLANK then move CCt type into parameter list
      *
     C                   EVAL      @CCtTyp = CctTyp
     C                   EVAL      @FilRef = FilRef
      *
     C                   ENDIF
      *
     C                   Z-ADD     SQ102A        @KPRT
     C                   Z-ADD     SQ102A        Phpart
      *
     C                   MOVEL     SwiftR        SSwtN            28
      *
     C                   IF        SSwtN <> *BLANKS and
     C                             ACTN = 'I'
      *
      ** The swift reference may hold either a '?' or an actual swift
      ** reference. The called program will determine which.
      *
     C                   CALL      'ME1080'                             90
     C                   PARM      '*KEY'        @Act              7
     C     PhmsgR        PARM      *ZEROS        @MsgR             8 0
     C                   PARM                    @Kprt             3 0
     C                   PARM      SSwtN         @Mor             28
     C     SwiftR        PARM      SSwtN         @Mir             28
     C                   PARM      *BLANKS       @Rtn              7
      *
      ** If there is an electronic message for the current job then
      ** prepare input fields for processing
      *
     C                   SELECT
      *
      ** If call to program resulted in an error then end program
      *
     C                   WHEN      @RTN = '*ERROR*' or *IN90
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     SSwtN         Dbkey
     C                   MOVEL     'ME1080  '    Dbfile
     C                   MOVEL     '002'         Dbase
     C                   EXSR      *PSSR
      *
      ** F3 pressed - exit program
      *
     C                   WHEN      @RTN = 'Y2U9999'
     C                   MOVE      '03'          @KeyP
     C                   GOTO      ExRtv
      *
      ** F12 pressed - exit program
      *
     C                   WHEN      @RTN = 'USR0790'
     C                   MOVE      '12'          @KeyP
     C                   GOTO      ExRtv
      *
      ** Messages that are selected using the '?' facility are reserved
      ** at time of selection.
      *
      ** If MIN0105 - Reserved message found - no errors processed
     C                   WHEN      @RTN = 'MIN0105'
      *
      ** Message already reserved for this job - no errors processed
     C                   WHEN      @RTN = 'MIN0103'
      *
      ** Valid message selected not reserved yet
     C                   WHEN      @RTN = 'MIN0112'
     C                   CALL      'ME1070'                             90
     C                   PARM      '*RESERV'     @Act              7
     C                   PARM                    @MsgR
     C                   PARM                    @Kprt
     C                   PARM                    @Mor
     C                   PARM                    @Mir
     C                   PARM      *Blanks       @Rtn
      *
     C                   IF        *IN90 = *ON
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'ME1070'      Dbfile
     C                   MOVEL     '*CALL'       Dbkey
     C                   MOVEL     '003'         Dbase
     C                   EXSR      *PSSR
     C                   MOVEL     *BLANKS       SSwtN
     C                   ENDIF
      *
     C                   IF        @RTN <> 'MIN0109'
     C                   Movel     'N'           OKSwfRf
     C                   ADD       1             Ix
     C                   MOVEL     'ME1070'      FldNameArr(Ix)
     C                   MOVEL     @RTN          MsgIdArr(Ix)
     C                   GOTO      ExRtv
     C                   ENDIF
      *
     C                   OTHER
     C                   MOVEL     'N'           OKSwfRf
     C                   ADD       1             Ix
     C                   MOVEL     'ME1080'      FldNameArr(Ix)
     C                   MOVEL     @RTN          MsgIdArr(Ix)
     C                   GOTO      ExRtv
     C                   ENDSL
 
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
      *
      ** Retrieve contents of the message
      *
     C     Ix            IFEQ      0
     C                   EXSR      RTVMSG
     C                   ENDIF
      *
      ** Translate existing tag values
      *
     C     Ix            IFEQ      0
     C                   EXSR      TRNTAG
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return
      *
     C     ExRtv         TAG
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** RTVMSG - Retrieve message details
      *****************************************************************
      *
     C     RTVMSG        BEGSR
      *
      ** Call ME1100 to translate the data of the messages for FT fields
      *
     C                   CALL      'ME1100'                             90
     C                   PARM      '*TRANS  '    #Act              8
     C                   PARM                    PHead
     C                   PARM      *BLANKS       PData
     C                   PARM      *BLANKS       PDat2                                        CSW209
     C                   PARM      *BLANKS       Rtn               7
      *
     C                   IF        RTN <> 'MIN0096' or *IN90
     C                   MOVEL     'N'           OKSwfRf
     C                   ADD       1             Ix
     C                   MOVEL     'ME1100'      FldNameArr(Ix)
     C                   MOVEL     'RFR0001'     MsgIdArr(Ix)
     C                   MOVEL     'RFR0001'     RetCodeIn
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** TRNTAG - Translate existing tag values
      *****************************************************************
      *
     C     TRNTAG        BEGSR
      *
      ** Call ME1580 to translate the data of the messages for FT fields
      *
     C                   CALL      'ME1580'                             90
     C                   PARM      '*TRANS  '    #Act              8
     C                   PARM                    PHead
     C                   PARM                    PData
     C                   PARM                    PDat2                                        CSW209
     C                   PARM      *BLANKS       Rtn               7
      *
     C                   IF        RTN <> *BLANKS or *IN90
     C                   MOVEL     'N'           OkSwfRf
     C                   ADD       1             Ix
     C                   MOVEL     'ME1580'      FldNameArr(Ix)
     C                   MOVEL     'RFR0002'     MsgIdArr(Ix)
     C                   MOVEL     'RFR0002'     RetCodeIn
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** Return code
      *
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    Actn              1
      ** CCt type
     C                   PARM                    @CCtTyp           2
     C                   PARM                    @FilRef          16
      ** (Midas) CCt ID
     C                   PARM                    CCtiDO           15
      ** Swift reference (ALSO OUPUT)
     C                   PARM                    SwiftR           28
      ** Message unique reference (for STP)
     C                   PARM                    MgmsgR
      ** CCt Header Record
     C                   PARM                    DDsCCtHdr
      ** Key Pressed
     C                   PARM                    @KeyP             2
      ** Details of the message
     C                   PARM                    PData
      ** Details of the message (Extension)                                                   CSW209
     C                   PARM                    PDat2                                        CSW209
      * Message ref array                                                       185660
     C                   PARM                    MREFARR                        185660
      * Message part array                                                      185660
     C                   PARM                    MPRTARR                        185660
      *
      ** Errors produced during retrieve operation
      *
     C                   PARM                    OkCCtHdB
     C                   PARM                    Ix
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTM1021RV'   Dbpgm
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*FIRST '     @Optn             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '006'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*FIRST '     @Optn             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database error
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'SDGELRPD'    Dbfile
     C                   MOVEL     '007'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Funds Transfer Details
      *
     C*******************CALL      'AOFODAR0'                                   184164
     C                   CALL      'AOFTFRR0'                                   184164
     C                   PARM      *BLANKS       @Rtcd             7
     C                   PARM      '*FIRST '     @Optn             7
     C*****SDFODA********PARM      SDFODA        DSFDY                          184164
     C     SDFTFR        PARM      SDFTFR        DSFDY                          184164
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     @OPTN         Dbkey
     C*******************Movel     'SDFODAPD'    DBFILE                         184164
     C                   Movel     'SDFTFRPD'    DBFILE                         184164
     C                   MOVEL     '008'         Dbase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ****GET*ZMUSER*to*access*default*branch.                                               BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
     C**********         UNLOCK    ZMUSER                                                    BUG7029
      *
     C                   CALLB     'ZACRTVJOBA'                         90
     C                   PARM                    PSJobName
     C                   PARM                    PSUser
     C                   PARM                    PSJobNo
     C                   PARM                    JobType           5
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*ERROR'      RetCodeIn
     C                   MOVEL     'FTM1021RV'   Dbpgm
     C                   MOVEL     'ZACRTVJOBA'  Dbfile
     C                   MOVEL     '009'         Dbase
     C                   MOVEL     '*CALL'       Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
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
