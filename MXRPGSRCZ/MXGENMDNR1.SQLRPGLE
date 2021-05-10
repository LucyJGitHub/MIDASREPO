     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*XBIA*  CRTPF QTEMP/OUTFILE RCDLEN(80)                               *
/*XBIB*  OVRDBF FILEOUT QTEMP/OUTFILE                                 *
/**** *  RPGBASEMOD                                                   *          MD056612
/*STD *  RPGSQLMOD                                                    *          MD056612
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *          MD056612
/*EXI *  TEXT('Midas MX Generate Meridian sub-message')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGENMDNR1 - Generate Meridian sub-message                   *
      *                                                               *
      *  Function:  This module reads records from the Export Format  *
      *             Fields file and writes them to a temporary file   *
      *             in QTEMP in the format of a Meridian 1.7          *
      *             Message or Sub-Message.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056612           Date 12Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056612 - Deliverable Data Split for MX group               *
      *  MD046248 - Finastra Rebranding                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
      /EJECT
     F*MXEXFDL2* IF   E           K DISK                                                    MD056612

     F*MXEXFFPD* IF   E           K DISK                                                    MD056612

      * The prefix keyword is used to rename the field to FOUTFILE to avoid
      * conflict with the file name.
     FFILEOUT   O    E             DISK    PREFIX(F)

      * ReturnCode constants
     D FileError       C                   Const('FileError')
     D NoRecord        C                   Const('NoRecord')

      * Meridian constants

     D TagMsgStart     C                   '<MESSAGE>'
     D TagSubMsgStart  C                   '<COMMONBLOCK>'

     D TagSystem       C                   '<SYSTEM>EXPORT'

     D TagMsgEnd       C                   '</MESSAGE>'
     D TagSubMsgEnd    C                   '</COMMONBLOCK>'

     D TagFieldStart   C                   '<FIELD>'
     D TagFieldEnd     C                   '</FIELD>'

     D TagFieldLength  C                   '<LENGTH>'

     D TagFieldType    C                   '<TYPE>'

     D TagBlank        C                   '        '

     D TagFldDescStr   C                   '<DESCRIPTION>'
     D TagFldDescEnd   C                   '</DESCRIPTION>'

      * Field Name Length information
     D MaxMdnFldNameLen...
     D                 C                   CONST(32)
     D EffMaxMdnFldNameLen...
     D                 S              3P 0

      * Parameters
      *   Format to be processed
     D InFormat        S             10A
      *   Target Meridian (Sub) Message name
     D TargetName      S             32A
      *   Prefix to be applied
     D Prefix          S             10A
      *   Generate a MESSAGE or a SUBMESSAGE
     D GenType         S             11A
      *   Do Type Matching on message
     D TypeMatch       S              1A
      *   Return Code
     D ReturnCode      S             10A

      * Work Fields
     D KeyFile         S             10A
     D KeySequence     S              1A
     D Length          S             10S 0

     D DataFound       S              1A
     D LastUsedElement...
     D                 S              2P 0
     D LUE             S              2P 0
     D NextDesc        S              2P 0

      *  WHDS01        78A
      * Description fields as an array
     D DescFlds        DS
     D**WHDS01*                                                                             MD056612
     D**WHDS02*                                                                             MD056612
     D**WHDS03*                                                                             MD056612
     D**WHDS04*                                                                             MD056612
     D**WHDS05*                                                                             MD056612
     D**WHDS06*                                                                             MD056612
     D**WHDS07*                                                                             MD056612
     D**WHDS08*                                                                             MD056612
     D**WHDS09*                                                                             MD056612
     D**WHDS10*                                                                             MD056612
     D**WHDS11*                                                                             MD056612
     D  XHDS01                 1     78                                                     MD056612
     D  XHDS02                79    156                                                     MD056612
     D  XHDS03               157    234                                                     MD056612
     D  XHDS04               235    312                                                     MD056612
     D  XHDS05               313    390                                                     MD056612
     D  XHDS06               391    468                                                     MD056612
     D  XHDS07               469    546                                                     MD056612
     D  XHDS08               547    624                                                     MD056612
     D  XHDS09               625    702                                                     MD056612
     D  XHDS10               703    780                                                     MD056612
     D  XHDS11               781    858                                                     MD056612
     D DescFldsArray                       like(WHDS01) dim(11)
     D                                     overlay(DescFlds)
     D MXEXFD        E DS                  EXTNAME(MXEXDJW0)                                MD056612
     D MXEXFF        E DS                  EXTNAME(MXEXFJW0)                                MD056612

      * Use the format received as a parameter to initially access the
      *  Export Format Details file to get details of the file etc
      *  associated with the format.
     C*****InFormat      CHAIN(E)  MXEXFDL2                                                 MD056612
     C/EXEC SQL                                                                             MD056612
     C+ SELECT *                                                                            MD056612
     C+ into :MXEXFD                                                                        MD056612
     C+ from MXEXDJW0                                                                       MD056612
     C+ where EXFMT  = :InFormat                                                            MD056612
     C/END-EXEC                                                                             MD056612
     C**********         IF        %Error                                                   MD056612
     C                   IF        SQLCODE < 0                                              MD056612
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         IF        NOT %Found                                               MD056612
     C                   IF        SQLCODE = 100                                            MD056612
     C                   EVAL      ReturnCode = NoRecord
     C                   RETURN
     C                   ENDIF

      * Use the retrieved file name etc to access all the records from the
      *  Export Format Fields file, and write each one to the target file.

      * - write out the initial 'once only' data
     C                   IF        GenType = '*MESSAGE'
     C                   EVAL      FOUTFILE = TagMsgStart + TargetName
     C                   ELSE
     C                   EVAL      FOUTFILE = TagSubMsgStart + TargetName
     C                   ENDIF
     C                   WRITE     OUTFILE

     C                   EVAL      FOUTFILE = TagSystem
     C                   WRITE     OUTFILE

      * - set up the prefix if required
     C                   IF        Prefix = '*FROMDBF'
     C                   EVAL      Prefix = EXFILE
     C                   ENDIF

      * - set up the effective max length for a field name
     C                   IF        Prefix <> '*DFT'
     C                   EVAL      EffMaxMdnFldNameLen = MaxMdnFldNameLen -
     C                               %len(%trim(Prefix))
     C                   ENDIF

      * - loop around all the records processing each one
     C                   EXSR      MAINLOOP

      * - write the end tags
     C                   IF        GenType = '*MESSAGE'
     C                   EVAL      FOUTFILE = TagMsgEnd
     C                   ELSE
     C                   EVAL      FOUTFILE = TagSubMsgEnd
     C                   ENDIF
     C                   WRITE     OUTFILE

     C                   EVAL      FOUTFILE = TagBlank
     C                   WRITE     OUTFILE

     C                   SETON                                        LR
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      * MainLoop - Subroutine to do the main processing, in a loop    *
      *                                                               *
      *****************************************************************

     C     MAINLOOP      BEGSR


      * Set up the keys and position to the start of the records
     C                   EVAL      KeyFile = EXFILE
     C                   EVAL      KeySequence = EXFSQN

     C*****MXEXFFK       SETLL     MXEXFFPD
     C/EXEC SQL                                                                             MD056612
     C+ declare FCursor insensitive scroll cursor for                                       MD056612
     C+ select * from MXEXFJW0                                                              MD056612
     C+ where WHFILE = :KeyFile and WHFSQN = :KeySequence                                   MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ open FCursor                                                                        MD056612
     C/END-EXEC                                                                             MD056612
                                                                                            MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch prior from FCursor into :MXEXFF                                               MD056612
     C/END-EXEC                                                                             MD056612
     C**********         IF        %Error                                                   MD056612
     C                   IF        SQLCODE < 0                                              MD056612
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF

     C**********         IF        NOT %Equal                                               MD056612
     C                   IF        SQLCODE = 100                                            MD056612
     C                   EVAL      ReturnCode = NoRecord
     C                   RETURN
     C                   ENDIF

     C*****MXEXFFK       READE(E)  MXEXFFPD                                     *           MD056612
     C**********         IF        %Error                                                   MD056612
     C**********         EVAL      ReturnCode = FileError                                   MD056612
     C**********         EXSR      *PSSR                                                    MD056612
     C**********         ENDIF                                                              MD056612

      * Process all records in turn
     C**********         DOW       NOT %EOF                                                 MD056612
     C                   DOW       SQLCODE = 0                                              MD056612

      * Only output data if the Include In Export flag is on
     C                   IF        WHINEX = 'Y'

      * Output <FIELD>, <LENGTH) and </FIELD> records

      * - for <FIELD> record include the Prefix if specified
     C                   IF        Prefix = '*DFT'
     C                   EVAL      FOUTFILE = TagFieldStart + WHMFNM
     C                   ELSE
     C                   EVAL      FOUTFILE = TagFieldStart +
     C                                        %trim(Prefix) +
     C                              %subst(WHMFNM:1:EffMaxMdnFldNameLen)
     C                   ENDIF
     C                   WRITE     OUTFILE

      * - for <LENGTH> record, use Number of Digits + 2 for Packed/Signed
      *   and Number of Bytes for all other cases
     C                   IF        WHFLDT = 'P' OR WHFLDT = 'S'
     C                   EVAL      Length = WHFLDD + 2
     C                   ELSE
     C                   EVAL      Length = WHFLDB
     C                   ENDIF

      *    - convert length to alpha before output
     C                   EVAL      FOUTFILE = TagFieldLength +
     C                              %trim(%editc(Length:'3'))

     C                   WRITE     OUTFILE

      * - for <TYPE> record, output only if numeric (default is String)
     C                   IF        TypeMatch = 'Y'
     C                   IF        WHFLDT = 'P' OR WHFLDT = 'S'
     C                   EVAL      FOUTFILE = TagFieldType + 'Number'
     C                   WRITE     OUTFILE
     C                   ENDIF
     C                   ENDIF

      * - Description records
     C                   EXSR      Description

      * - </FIELD> record
     C                   EVAL      FOUTFILE = TagFieldEnd
     C                   WRITE     OUTFILE

     C                   ENDIF

      * Get next record
     C*****MXEXFFK       READE(E)  MXEXFFPD                                     *           MD056612
     C/EXEC SQL                                                                             MD056612
     C+ fetch prior from FCursor into :MXEXFF                                               MD056612
     C/END-EXEC                                                                             MD056612
     C**********         IF        %Error                                                   MD056612
     C                   IF        SQLCODE < 0                                              MD056612
     C                   EVAL      ReturnCode = FileError
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDDO

     C/EXEC SQL                                                                             MD056612
     C+ close FCursor                                                                       MD056612
     C/END-EXEC                                                                             MD056612
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Description - output Description records if any are present   *
      *                                                               *
      *****************************************************************

     C     Description   BEGSR

      * Check to see if there is any description data present
     C                   EVAL      DataFound = 'N'
     C                   EVAL      LastUsedElement = 0

     C                   eval      XHDS01 = WHDS01                                          MD056612
     C                   eval      XHDS02 = WHDS02                                          MD056612
     C                   eval      XHDS03 = WHDS03                                          MD056612
     C                   eval      XHDS04 = WHDS04                                          MD056612
     C                   eval      XHDS05 = WHDS05                                          MD056612
     C                   eval      XHDS06 = WHDS06                                          MD056612
     C                   eval      XHDS07 = WHDS07                                          MD056612
     C                   eval      XHDS08 = WHDS08                                          MD056612
     C                   eval      XHDS09 = WHDS09                                          MD056612
     C                   eval      XHDS10 = WHDS10                                          MD056612
     C                   eval      XHDS11 = WHDS11                                          MD056612
                                                                                            MD056612
     C     1             DO        11            NextDesc

     C                   IF        DescFldsArray(NextDesc) <> *BLANK
     C                   EVAL      DataFound = 'Y'
     C                   EVAL      LastUsedElement = NextDesc
     C                   ENDIF

     C                   ENDDO

      * If there is any description data present output
      * - starting tag
      * - all entries (including blank ones) up to the last non-blank one
      * - ending tag

     C                   IF        DataFound = 'Y'

     C                   EVAL      FOUTFILE = TagFldDescStr
     C                   WRITE     OUTFILE

     C                   EVAL      LUE = LastUsedElement
     C     1             DO        LUE           NextDesc
     C                   EVAL      FOUTFILE = DescFldsArray(NextDesc)
     C                   WRITE     OUTFILE
     C                   ENDDO

     C                   EVAL      FOUTFILE = TagFldDescEnd
     C                   WRITE     OUTFILE
     C                   ENDIF

     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    InFormat
     C                   PARM                    TargetName
     C                   PARM                    Prefix
     C                   PARM                    GenType
     C                   PARM                    TypeMatch
     C                   PARM                    ReturnCode

     C     MXEXFFK       KLIST
     C                   KFLD                    KeyFile
     C                   KFLD                    KeySequence

     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END

     C                   SETON                                        U7U8LR
     C                   RETURN

     C                   ENDSR
      ********************************************************************
