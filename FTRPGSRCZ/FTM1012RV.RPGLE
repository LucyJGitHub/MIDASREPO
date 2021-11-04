     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT RFT credit retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTM1012RV - Request for Transfer Payments - Detail Retrieve  *
      *                                                               *
      *  Function:  This module retrieves a credit record from Midas  *
      *             database.                                         *
      *  Depending the input parameters it can return :-              *
      *  a credit record format                                       *
      *  a MT101 sequence B format                                    *
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
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 30May00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185660             Date 31Oct00               *
      *                 184164             Date 31Oct00               *
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
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  185660 - When routing using ?,all message parts should be    *
      *         - processed                                           *
      *  184164 - Replace access to SDFODAPD to SDFTFRPD              *
      *  185107 - Mapping of details from swift message               *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFT101DL0  IF   E           K DISK    INFSR(*PSSR)
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

     D QUESTION        C                   CONST(-99)
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      **  Data structure for file status of FT deals file.
     D INFDS           DS
     D  RECORD           *RECORD

     D OkRftDtB      E DS                  EXTNAME(FTE101BPD)
      ** EXTERNAL DS FOR OK FLAGS DETAIL

     D DDsRftDtl     E DS                  EXTNAME(FT101DPD)
      ** EXTERNAL DS FOR RFT DETAIL

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
     D Ix              S              3P 0

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
      *
      *                                                                                      BUG7029
      **  GET ZMUSER to access default branch.                                               BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029
     C                   Clear                   DdsRftDtl
     C                   Clear                   PDATA
     C                   CLEAR                   PDAT2                                        CSW209
     C                   Clear                   PHEAD
     C                   Movel     *ALL'Y'       OkRftDtB
     C                   Z-add     0             Ix
     C                   Movel     *BLANK        FldNameArr
     C                   Movel     *BLANK        MsgIdArr
     C                   Movel     *BLANK        MsgDtaArr
     C                   Movel     *BLANK        RetCodeIn
     C                   Z-ADD     0             MX                             185660


     C                   Select

      ** Particular case, where if message key is entered we will return
      ** a RFT message format
     C                   When      MGMSGR <> 0
     C                   Move      MGMSGR        PHMSGR
     C                   Z-ADD     0             @KPRT                          185107
     C                   MOVE      SQ101B        @KPRT                          185107

      ** Retrieve contents of the message
     C     Ix            Ifeq      0
     C                   Exsr      RTVMSG
     C                   Endif

      ** Translate existing tag values
     C     Ix            Ifeq      0
     C                   Exsr      TRNTAG
     C                   Endif

      ** Others cases, a RFT record format is returned
     C                   When      ACTN = 'I'
     C                   Exsr      InsertRcd

     C                   When      ACTN = 'X'
     C                   If        TRANSR = *Blanks
     C     RftIdo        Setll     FT101DL0
     C     RftIdo        Reade     FT101DL0                               90
      * If no transaction records, send message back.

     C                   If        *IN90 = *On
     C                   Eval      RetCodeIn = '*NORECORD  '
     C                   Endif
     C                   Else
     C     KRftDtl       Chain     FT101DL0                           90
     C                   Endif

     C                   Other
      * Just retrieve record
     C     KRftDtl       Chain     FT101DL0                           90
     C                   If        *IN90 = '1'
     C                   Movel     'RFTIDO '     DBKEY
     C                   Z-add     1             DBASE
     C                   Movel     '*ERROR'      RetCodeIn
     C                   Exsr      *PSSR
     C                   EndIf
     C                   Endsl

      * Return
     C     ExRtv         TAG
     C                   RETURN

      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * InsertRcd - Insert Record
      *****************************************************************
     C     InsertRcd     Begsr

      *
     C                   Movel     SWIFTR        SSWTN            28
      *
     C                   If        SSWTN  <> *Blanks and
     C                             ACTN = 'I'
     C                   If        SQ101B = *BLANK or SQ101B = *ZEROS
     C                   Move      1             SQ101B
     C                   Else
     C                   If        %scan('?':SQ101B) <> 0
     C                   Move      QUESTION      SQ101B
     C                   Endif
     C                   Endif
      *
      *  The swift reference may hold either a '?' or an actual swift
      *  reference. The called program will determine which.
      *
     C                   Move      SQ101B        @KPRT
     C                   Call      'ME1080'                             90
     C                   Parm      '*KEY'        @ACT              7
     C     PHMSGR        Parm      *ZEROS        @MSGR             8 0
     C                   Parm                    @KPRT             3 0
     C                   Parm      SSWTN         @MOR             28
     C     SWIFTR        Parm      SSWTN         @MIR             28
     C                   Parm      *BLANKS       @RTN              7
      *
      * If call to program resulted in an error then end program
      *
     C                   If        @RTN = '*ERROR*' or *IN90
     C                   Movel     SSWTN         DBKEY
     C                   Movel     'ME1080  '    DBFILE
     C                   Z-add     2             DBASE
     C                   Exsr      *PSSR
     C                   Endif
      *
      *  F3 or F12 pressed - exit module
      *
     C                   If        @RTN = 'Y2U9999'
     C                   Move      '03'          @KeyP
     C                   Return
     C                   Endif
      *
     C                   If        @RTN = 'USR0790'
     C                   Move      '12'          @KeyP
     C                   Return
     C                   Endif
      *
      * If '?' was entered
      * ------------------
      *
      * If MIN0105 - Reserved message found
      *
      * If there is an electronic message for the current job then
      * prepare input fields for processing
      *
      * Messages that are selected using the '?' facility are reserved
      * at time of selection.
     C                   Select
      *
      * Reserved message found
     C                   When      @RTN = 'MIN0105'
      *
      * Message already reserved for this job
     C                   When      @RTN = 'MIN0103'
      *
      * Valid message selected not reserved yet
     C                   When      @RTN = 'MIN0112'
     C                   Call      'ME1070'
     C                   Parm      '*RESERV'     @ACT              7
     C                   Parm                    @MSGR
     C                   Parm                    @KPRT
     C                   Parm                    @MOR
     C                   Parm                    @MIR
     C                   Parm      *Blanks       @RTN
      *
     C                   If        *IN90
     C                   Movel     'ME1070'      DBFILE
     C                   Movel     '*CALL'       DBKEY
     C                   Z-add     3             DBASE
     C                   Exsr      *PSSR
     C                   Movel     *BLANKS       SSWTN
     C                   Endif
      *
     C                   If        @RTN <> 'MIN0109'
     C                   Movel     'N'           DDSWSEQOK
     C                   Movel     'N'           DDSWREFOK
     C                   Add       1             Ix
     C                   Movel     'ME1070'      FldNameArr(Ix)
     C                   Movel     @RTN          MsgIdArr(Ix)
     C                   Movel     @RTN          RetCodeIn
     C                   Return
     C                   Endif
      *
     C                   Other
     C                   Movel     'N'           DDSWSEQOK
     C                   Movel     'N'           DDSWREFOK
     C                   Add       1             Ix
     C                   Movel     'ME1080'      FldNameArr(Ix)
     C                   Movel     @RTN          MsgIdArr(Ix)
     C                   Movel     @RTN          RetCodeIn
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

     C                   Endsr
      /EJECT
      *****************************************************************
      ** RTVMSG - Retrieve message details
      *****************************************************************
     C     RTVMSG        Begsr
      *
      * Call ME1100 to translate the data of the messages for FT fields
      *
     C                   MOVE      @KPRT         PHPART
     C                   Call      'ME1100'                             90
     C                   Parm      '*TRANS  '    #ACT              8
     C                   Parm                    PHEAD
     C                   Parm      *Blanks       PDATA
     C                   PARM      *BLANKS       PDAT2                                        CSW209
     C                   Parm      *Blanks       RTN               7

     C                   If        RTN <> 'MIN0096' or *IN90
     C                   Movel     'N'           DDSWSEQOK
     C                   Movel     'N'           DDSWREFOK
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
     C                   Movel     'N'           DDSWSEQOK
     C                   Movel     'N'           DDSWREFOK
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
      * (Midas) RFT ID
     C                   Parm                    RFTIDO           15
     C                   Parm                    TRANSR           16
     C                   Parm                    SWIFTR           28
     C                   Parm                    SQ101B            2
      * Message unique reference (for STP)
     C                   Parm                    MGMSGR
      * RFT Detail Record
     C                   Parm                    DDsRftDtl
      * Key Pressed
     C                   Parm                    @Keyp             2
      * Details of the message
     C                   Parm                    Phead
     C                   Parm                    Pdata
     C                   PARM                    PDAT2                                        CSW209
      * Message ref array                                                       185660
     C                   PARM                    MREFARR                        185660
      * Message part array                                                      185660
     C                   PARM                    MPRTARR                        185660
      ** Errors produced during retrieve operation
     C                   PARM                    OkRftDtB
     C                   PARM                    Ix
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Initialize program name

     C                   Movel     'FTM1012RV'   DBPGM
      *
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
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Z-add     6             DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
      ** Access General Ledger Details
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
     C                   Movel     'SDGELRPD'    DBFILE
     C                   Z-add     7             DBASE
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
     C                   Movel     @OPTN         DBKEY
     C*******************Movel     'SDFODAPD'    DBFILE                         184164
     C                   Movel     'SDFTFRPD'    DBFILE                         184164
     C                   Z-add     8             DBASE
     C                   Exsr      *PSSR
     C                   Endif
      *
     C     KRftDtl       Klist
     C                   Kfld                    RFTIDO
     C                   Kfld                    TRANSR
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
     C                   Movel     'FTM1012RV'   DBPGM
     C                   Movel     'ZACRTVJOBA'  DBFILE
     C                   Z-add     9             DBASE
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
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
