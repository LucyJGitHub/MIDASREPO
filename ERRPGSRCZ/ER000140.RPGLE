     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas @24 KWG rename response file')                   *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000140 - Midas @24 KWG  rename response file               *
      *                                                               *
      *  Function:  This program renames all response files found     *
      *             in the response folder to the name found in the   *
      *             A-record of the file.                             *
      *             This function is only executed for response files *
      *             from Bank-Verlag.                                 *
      *                                                               *
      *  Component of: ER000140                                       *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 262095             Date 14Oct09               *
      *                 CER047  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262095 - Change BankName to ServiceProvider.                 *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    98         Multi-purpose                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** ERTRCVPD - Midas @24 KWG response work file
      *
     FERTRCVPD  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      ** ERSPOOL - spool work file
      *
     FERSPOOL   IF   F   20        DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the Db error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined field in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Declare constants for the call of 'AOSVALR0'
      *
     D WVal01          C                   'ResponseFileFolder'
     D WVal02          C                   'DataFormat'
     D WVal03          C                   'RenameResponseFile'
     D*WVal04***       C                   'BankName'                                         262095
     D WVal04          C                   'ServiceProvider'                                  262095
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Data Structures
      *
     D DSK24Ab         DS            80
     D  WAbLen                 1      4I 0 INZ(80)
     D  WAbRtp                 5      5    INZ('A')
     D  WAbVId                 6     11S 0
     D  WAbBkN                12     15
     D  WAbVer                16     21
     D  WAbDat                22     29
     D  WAbTim                30     35
     D  WAbFnr                36     41S 0
     D  WAbFtp                42     43
     D  WAbUtp                44     44
     D  WAbLid                45     46S 0
     D  WAbFnm                47     58
      *
      ** Unsigned Integer value of a character
      *
     D                 DS
     D  Puns                         10U 0 INZ(0)
     D  Pchr                          1A   OVERLAY(Puns:4)
      *
      **  Call to C procedure
      *
     D ER000113        PR            10I 0
     D   Path                       100A   CONST
     D   Puns                        10U 0 VALUE
      *
      ** Call to EBCDIC <-> ASCII translation procedure
      *
     D Translate       PR         32760A   OPDESC
     D  PTransFrom                    6A   CONST
     D  PString                   32760A   CONST OPTIONS(*VARSIZE)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Variables
      *
     D Path            S            100A
     D WRcdTyp         S              1A
     D WRtnCde         S              1S 0
     D WCmd            S           2000A
     D WLen            S             15P 5
     D WkVl02          S              6A
      *
      ** Parameters for the call of 'AOSVALR0'
      *
     D PRtCd           S              7A
     D POp01           S             20A
     D POp02           S             20A
     D POp03           S             20A
     D POp04           S             20A
     D POp05           S             20A
     D POp06           S             20A
     D POp07           S             20A
     D POp08           S             20A
     D POp09           S             20A
     D POp10           S             20A
      *
     D PVl01           S            200A
     D PVl02           S            200A
     D PVl03           S            200A
     D PVl04           S            200A
     D PVl05           S            200A
     D PVl06           S            200A
     D PVl07           S            200A
     D PVl08           S            200A
     D PVl09           S            200A
     D PVl10           S            200A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Declaration of Input Specification
      *
     IERSPOOL   NS
     I                                  1   20  WFnm
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: the *INZ   ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Try to get response file
      *
     C                   READ      ERSPOOL
     C                   DOW       NOT(%EOF)
      *
      ** Copy file to database workfile via C-Program
      *
     C                   EVAL      Path = %TRIM(%SUBST(PVl01:1:60)) +
     C                                    %TRIM(WFnm) +
     C                                    X'00'
     C                   EVAL      WRtnCde = ER000113(Path:Puns)
      *
      **  Response file found
      *
     C                   IF        WRtnCde = 0
      *
      ** Open workfile
      *
     C                   OPEN      ERTRCVPD
      *
      ** Read workfile
      *
     C                   READ      ERTRCVD0
      *
      ** Extract Record Type
      *
     C                   EVAL      WkVl02 = %SUBST(PVl02:1:6)
     C                   EVAL      WRcdTyp =
     C                             Translate(WkVl02:%SUBST(F1WDTA:5:1))
      *
      ** If record type is 'A' extract file name
      *
     C                   IF        WRcdTyp = 'A'
      *
      ** Move data to data structure of 'A' record
      *
     C                   EVAL      DSK24Ab = F1WDTA
     C                   EVAL      %SUBST(DSK24Ab:5) =
     C                             Translate(WkVl02:%SUBST(F1WDTA:5))
      *
      ** Rename file if file is of type 'IB'
      *
     C                   IF        WAbFtp = 'IB'
     C                   EVAL      WCmd = 'RNM OBJ(''' +
     C                             %TRIM(%SUBST(PVl01:1:60)) +
     C                             %TRIM(WFnm) + ''') NEWOBJ(''' +
     C                             %TRIM(WAbFnm) + ''')'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Close workfile
      *
     C                   CLOSE     ERTRCVPD
      *
     C                   ENDIF
      *
      ** Read next record
      *
     C                   READ      ERSPOOL
     C                   ENDDO
      *
      ** End the program
      *
     C                   CLOSE     ERTRCVPD
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialization routine                      *
      *                                                               *
      *  Called by : Implicitly on program activation                 *
      *                                                               *
      *  Calls : None                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      WVal01        POp01
     C                   PARM                    PVl01
     C                   PARM      WVal02        POp02
     C                   PARM                    PVl02
     C                   PARM      WVal03        POp03
     C                   PARM                    PVl03
     C                   PARM      WVal04        POp04
     C                   PARM                    PVl04
     C                   PARM      *BLANKS       POp05
     C                   PARM                    PVl05
     C                   PARM      *BLANKS       POp06
     C                   PARM                    PVl06
     C                   PARM      *BLANKS       POp07
     C                   PARM                    PVl07
     C                   PARM      *BLANKS       POp08
     C                   PARM                    PVl08
     C                   PARM      *BLANKS       POp09
     C                   PARM                    PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM                    PVl10
      *
     C                   IF        PRtCd  <> *BLANKS
      *
     C                   IF        PVl01 = '*NRF   '
     C                   EVAL      DBKEY = POp01
     C                   ENDIF
      *
     C                   IF        PVl02 = '*NRF   '
     C                   EVAL      DBKEY = POp02
     C                   ENDIF
      *
     C                   IF        PVl03 = '*NRF   '
     C                   EVAL      DBKEY = POp03
     C                   ENDIF
      *
     C                   IF        PVl04 = '*NRF   '
     C                   EVAL      DBKEY = POp04
     C                   ENDIF
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'ER000140'
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve information from System Value SDSVALPD
      *
     C                   IF        %SUBST(PVl04:1:1) <> 'B' OR
     C                             %SUBST(PVl03:1:1) <> 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Delete spool work file
      *
     C                   EVAL      WCmd = 'DLTF FILE(QTEMP/ERSPOOL)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Create spool work file
      *
     C                   EVAL      WCmd = 'CRTPF FILE(QTEMP/ERSPOOL) +
     C                             RCDLEN(20)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Override spool work file
      *
     C                   EVAL      WCmd = 'OVRDBF FILE(ERSPOOL) +
     C                             TOFILE(QTEMP/ERSPOOL)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Display links in path
      *
     C                   EVAL      WCmd = 'DSPLNK OBJ(''' +
     C                             %TRIM(PVl01) +
     C                             '*'') OUTPUT(*PRINT) DETAIL(*NAME) +
     C                             DSPOPT(*USER)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Copy spool file to spool work file
      *
     C                   EVAL      WCmd = 'CPYSPLF FILE(QSYSPRT) +
     C                             TOFILE(QTEMP/ERSPOOL) SPLNBR(*LAST)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Delete spool file
      *
     C                   EVAL      WCmd = 'DLTSPLF FILE(QSYSPRT) +
     C                                    SPLNBR(*LAST)'
     C                   EVAL      WLen = %LEN(%TRIM(WCmd))
     C                   CALL      'QCMDEXC'                            98
     C                   PARM                    WCmd
     C                   PARM                    WLen
      *
      ** Open files
      *
     C                   OPEN      ERSPOOL
      *
      ** Set unsigned integer value for C-procedure
      *
     C                   EVAL      Pchr = PVl04
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Program, module and procedure names for Db error processing.
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRans - Procedure for EBCDIC <-> ASCII translation         *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     P Translate       B
     D Translate       PI         32760A   OPDESC
     D  PTransFrom                    6A   CONST
     D  PString                   32760A   CONST OPTIONS(*VARSIZE)
      *
      ** S Translate ASCII to EBCDIC, if requested
      ** Prototype for CEEDOD (Retrieve operational descriptor)
      *
     D CEEDOD          PR
     D  ParmNum                      10I 0 CONST
     D                               10I 0
     D                               10I 0
     D                               10I 0
     D                               10I 0
     D                               10I 0
     D                               12A   OPTIONS(*OMIT)
      *
      ** Parameters passed to CEEDOD
      *
     D PDescType       S             10I 0
     D PDataType       S             10I 0
     D PDescInfo1      S             10I 0
     D PDescInfo2      S             10I 0
     D PLength         S             10I 0
      *
      ** Definitions for procedure
      *
     D WRetString      S          32760A   INZ(' ')
      *
      ** Parametrs for Calling QDCXLATE
      *
     D PLengthOfData   S              5P 0
     D PConversnData   S           2000A
     D PSBCSTbleName   S             10A
      *
      ** Use the operational descriptor to determine the length of the
      ** parameter that were passed
      *
     C                   CALLP     CEEDOD(2:PDescType:PDataType:
     C                             PDescInfo1:PDescInfo2:PLength:*OMIT)
      *
      ** Translate
      *
     C                   EVAL      PSBCSTbleName = 'ER1' +
     C                                             %TRIM(PTransFrom)
     C                   CALL      'QDCXLATE'                           9898
     C                   PARM      PLength       PLengthOfData
     C     WRetString    PARM      PString       PConversnData
     C                   PARM                    PSBCSTbleName
      *
     C                   IF        *IN98
     C                   RETURN    %SUBST(PString:1:PLength)
     C                   ENDIF
      *
      ** Done; return translated string to caller
      *
     C                   RETURN    %SUBST(WRetString:1:PLength)
      *
     P Translate       E
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2008
