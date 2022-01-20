     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD056564
/*STD *  RPGSQLBND                                                    *                     MD056564
/*EXI *  TEXT('Midas AP Generate list of non-display fields')
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces module            *
      *                                                               *
      *  APCRTNDFLD - Create list of non-display fields               *
      *                                                               *
      *  Function: This module is used to generate a list of non-     *
      *            display fields for us in browsers.                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD059472           Date 19Jan22               *
      *  Prev Amend No. MD056565           Date 21Jan21               *
      *                 MD056564           Date 24Aug20               *
      *                 MD055681           Date 31Jul20               *
      *                 MD046657           Date 12Feb18               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP084  *CREATE    Date 26Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059472 - Introduce Logical Delete field                    *
      *  MD056565 - Deliverable Data Split for APDFFLDPD              *
      *  MD056564 - Deliverable Data Split for No Display field cond  *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046657 - Possibility to change non-amendable fields to be  *
      *             amendable and able to complete transaction        *
      *             (Recompile).                                      *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
      /EJECT

      ** File containing conditions under which fields are non-displayed
     F*APNDCONL0 IF   E           K DISK                                                    MD056564

      ** Output file containing list of non-displayed fields
     F*APDFFLDPD UF A E             DISK                                                    MD056565
     F**********                           INFDS(InfDS)                                     MD056565

      ** File containing switched on features
     F*SCSARDPD*IT   F    6        DISK    INFSR(*PSSR)                                     MD055681
     FSCSRDJW0  IT   F    6        DISK    INFSR(*PSSR)                                     MD055681

      ** File containing switched on modules
     FSDMMIDL3  IT   F   10        DISK    INFSR(*PSSR)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** The maximum size of the arrays
     D ArrayMax        C                   CONST(10)
     D ArrayMax2       C                   CONST(9999)

      ** Array of logical conditions
     D LogicArr        S                   Like(LogicDS)
     D                                     DIM(ArrayMax)

      ** Array of switched-on features
     D FeatArr         S              6A   DIM(ArrayMax2) PERRCD(1)
     D**********                           FROMFILE(SCSARDPD)                               MD055681
     D                                     FROMFILE(SCSRDJW0)                               MD055681

      ** Array of switched on modules
     D ModArr          S             10A   DIM(ArrayMax2) PERRCD(1)
     D                                     FROMFILE(SDMMIDL3)

      * DS to save/retrieve records from APNDCONL0 to/from array
     D*LogicDS**     E DS                  EXTNAME(APNDCONPD)                               MD056564
     D LogicDS       E DS                  EXTNAME(APNDCJW0)                                MD056564
     D SFName                 35     40
     D APDFFL        E DS                  EXTNAME(APDFLJW0)                                MD056565

      * File information data structure
     D InfDS           DS

     D Ix              S              3  0
     D Iy              S              3  0
     D NDCount         S              3  0
     D NonDisplay      S              1
     D NCDFLDS         S             10                                                     MD056564
     D NCAPDTS         S             20                                                     MD056564

      **********************************************************************
      /SPACE 5
      **********************************************************************
      * Start of main processing
      **********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
      *
      * Key list for APNDCONDL0
     C     CondKey       KLIST
     C                   KFLD                    NCAPDT
     C                   KFLD                    NCDFLD
     C                   KFLD                    NCSEQN

      * Delete first all the records (to replace CLRPFM)                                    MD056565
     C/EXEC SQL                                                                             MD056565
     C+ delete from APDFLCTD                                                                MD056565
     C+ where NDAPDT <> '                   '                                               MD056565
     C/END-EXEC                                                                             MD056565
     C/EXEC SQL                                                                             MD056565
     C+ delete from APDFLBTD                                                                MD056565
     C+ where NDAPDT <> '                   '                                               MD056565
     C/END-EXEC                                                                             MD056565
     C/EXEC SQL                                                                             MD056565
     C+ delete from APDFLXTD                                                                MD056565
     C+ where NDAPDT <> '                   '                                               MD056565
     C/END-EXEC                                                                             MD056565
      **--------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------

      * Get first record
     C**********         Read      APNDCONL0                              80                MD056564
     C/EXEC SQL                                                                             MD056564
     C+ declare ACursor insensitive scroll cursor for                                       MD056564
     C+ select * from APNDCJW0                                                              MD056564
     C+ order by NCAPDT, NCDFLD, NCSEQN                                                     MD056564
     C/END-EXEC                                                                             MD056564
                                                                                            MD056564
     C/EXEC SQL                                                                             MD056564
     C+ open ACursor                                                                        MD056564
     C/END-EXEC                                                                             MD056564
                                                                                            MD056564
     C/EXEC SQL                                                                             MD056564
     C+ fetch next from ACursor into :LogicDS                                               MD056564
     C/END-EXEC                                                                             MD056564
     C                   Z-ADD     1             Iy

      * Read all available records
     C**********         DoW       *IN80 = *Off                                             MD056564
     C                   DOW       SQLCODE = 0                                              MD056564

      * Save current condition to array
     C                   Eval      LogicArr(Iy) = LogicDS

      * If this is the end of the current set of conditions, check whether
      * they have been satisfied
     C                   If        NCLOGC <> '*AND'
     C                   EXSR      ChkLogic
     C                   Reset                   LogicArr
     C                   Z-ADD     0             Iy
     C                   EndIf

      * If the field is not to be displayed, write to outfile
     C                   If        NonDisplay = 'Y'
     C**********         Eval      NDAPDT = NCAPDT                                          MD056565
     C**********         Eval      NDDFLD = NCDFLD                                          MD056565
     C**********         Eval      NDTYPE = NCTYPE                                          MD056565
     C**********         Monitor                                                            MD056565
     C**********         Write     APDFFLDD0                            99                  MD056565
     C                   If        NCMODE = 'C'                                             MD056565
     C/exec SQL                                                                             MD056565
     C+ insert into APDFLCTD                                                                MD056565
     C+ (                                                                                   MD056565
     C+   NDAPDT                                                                            MD056565
     C+ , NDDFLD                                                                            MD056565
     C+ , NDTYPE                                                                            MD056565
     C+ , FILNAM                                                                            MD056565
     C+ , FLDNAM                                                                            MD056565
     C+ , FLMODE                                                                            MD056565
     C+ , FILNMX                                                                            MD056565
     C+ , FLDNMX                                                                            MD056565
     C+ , FLMODX                                                                            MD056565
     C+ , FILNMD                                                                            MD056565
     C+ , FLDNMD                                                                            MD056565
     C+ , FLMODD                                                                            MD056565
     C+ , NDMODE                                                                            MD056565
     C+ , FILGDL                                                                            MD059472
     C+ )                                                                                   MD056565
     C+ values                                                                              MD056565
     C+ (                                                                                   MD056565
     C+  :NCAPDT                                                                            MD056565
     C+ ,:NCDFLD                                                                            MD056565
     C+ ,:NCTYPE                                                                            MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , 'C'                                                                               MD056565
     C+ , 'N'                                                                               MD059472
     C+ )                                                                                   MD056565
     C/end-exec                                                                             MD056565
     C                   else                                                               MD056565
     C/exec SQL                                                                             MD056565
     C+ insert into APDFLBTD                                                                MD056565
     C+ (                                                                                   MD056565
     C+   NDAPDT                                                                            MD056565
     C+ , NDDFLD                                                                            MD056565
     C+ , NDTYPE                                                                            MD056565
     C+ , FILNAM                                                                            MD056565
     C+ , FLDNAM                                                                            MD056565
     C+ , FLMODE                                                                            MD056565
     C+ , FILNMX                                                                            MD056565
     C+ , FLDNMX                                                                            MD056565
     C+ , FLMODX                                                                            MD056565
     C+ , FILNMD                                                                            MD056565
     C+ , FLDNMD                                                                            MD056565
     C+ , FLMODD                                                                            MD056565
     C+ , NDMODE                                                                            MD056565
     C+ , FILGDL                                                                            MD059472
     C+ )                                                                                   MD056565
     C+ values                                                                              MD056565
     C+ (                                                                                   MD056565
     C+  :NCAPDT                                                                            MD056565
     C+ ,:NCDFLD                                                                            MD056565
     C+ ,:NCTYPE                                                                            MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , 'B'                                                                               MD056565
     C+ , 'N'                                                                               MD059472
     C+ )                                                                                   MD056565
     C/end-exec                                                                             MD056565
     C                   endif                                                              MD056565
     C/exec SQL                                                                             MD056565
     C+ insert into APDFLXTD                                                                MD056565
     C+ (                                                                                   MD056565
     C+   NDAPDT                                                                            MD056565
     C+ , NDDFLD                                                                            MD056565
     C+ , FILNAM                                                                            MD056565
     C+ , FLDNAM                                                                            MD056565
     C+ , FILNMX                                                                            MD056565
     C+ , FLDNMX                                                                            MD056565
     C+ , NDMODE                                                                            MD056565
     C+ , FILGDL                                                                            MD059472
     C+ )                                                                                   MD056565
     C+ values                                                                              MD056565
     C+ (                                                                                   MD056565
     C+  :NCAPDT                                                                            MD056565
     C+ ,:NCDFLD                                                                            MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , ' '                                                                               MD056565
     C+ , :NCMODE                                                                           MD056565
     C+ , 'N'                                                                               MD059472
     C+ )                                                                                   MD056565
     C/end-exec                                                                             MD056565

      * Any error other than 'Duplicate record' = database error
      * (We want to drop any duplicates)
     C**********         On-Error  1021                                                     MD056565
     C**********         On-Error  *File                                                    MD056565
     C                   If        SQLCODE < 0                                              MD056565
     C                   Exsr      *PSSR
     C                   Endif                                                              MD056565
     C**********         EndMon                                                             MD056565

      * In case the first half of an '*OR' statement has proved correct,
      * we don't want to process any other statements for this field.
      * Position to the end of the current set of records.
     C**********         Eval      NCSEQN = '999'                                           MD056564
     C*****CondKey       SetGT     APNDCONL0                                                MD056564
     C                   Eval      NonDisplay = ' '
     C                   Eval      NCDFLDS = NCDFLD                                         MD056564
     C                   Eval      NCAPDTS = NCAPDT                                         MD056564
     C     AGAIN         Tag                                                                MD056564
     C/EXEC SQL                                                                             MD056564
     C+ fetch next from ACursor into :LogicDS                                               MD056564
     C/END-EXEC                                                                             MD056564
     C                   If        SQLCODE = 0 and NCDFLD = NCDFLDS                         MD056564
     C                             and NCAPDT = NCAPDTS                                     MD056564
     C                   Goto      AGAIN                                                    MD056564
     C                   EndIf                                                              MD056564
     C/EXEC SQL                                                                             MD056564
     C+ fetch prior from ACursor into :LogicDS                                              MD056564
     C/END-EXEC                                                                             MD056564
     C                   EndIf

     C**********         Read      APNDCONL0                              80                MD056564
     C/EXEC SQL                                                                             MD056564
     C+ fetch next from ACursor into :LogicDS                                               MD056564
     C/END-EXEC                                                                             MD056564
     C                   Add       1             Iy
     C                   EndDo

     C/EXEC SQL                                                                             MD056564
     C+ close ACursor                                                                       MD056564
     C/END-EXEC                                                                             MD056564
     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      /SPACE 5
      ****************************************************************
      * Check logic conditions
      ****************************************************************
     C     ChkLogic      BEGSR

     C                   Z-ADD     1             Ix
     C                   Z-ADD     0             NDCount
     C                   DO        ArrayMax

     C                   If        LogicArr(Ix) = *Blank
     C                   Leave
     C                   EndIf

     C                   EVAL      LogicDS = LogicArr(Ix)

      * Check for existence of feature or module as appropriate
      * Feature.....
     C                   If        NCMODF = 'S'
     C     SFName        LOOKUP    FeatArr                                20

      * Module......
     C                   Else
     C     NCMDFN        LOOKUP    ModArr                                 20
     C                   EndIf

      * Add 1 to the number of logical true counts depending on whether
      * the feature/module should be present or absent.
     C                   If        *IN20 = '1' and
     C                             NCMINS = 'Y'
     C                   Add       1             NDCount
     C                   EndIf
     C                   If        *IN20 = '0' and
     C                             NCMINS = 'N'
     C                   Add       1             NDCount
     C                   EndIf

     C                   Add       1             Ix
     C                   EndDo

      * If the number of nondisplay counts is the same as the number of
      * logical statements, then they have all been proved true.  Set
      * flag to write to outfile.
     C                   If        NDCount = Iy
     C                   Eval      NonDisplay = 'Y'
     C                   EndIf

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   EVAL      ReturnCode = '*Error'
     C                   RETURN
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2003
