     H DEBUG NOMAIN
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPSTRPRCS - Procedures for string handling                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Last Amend No. CRP013  *CREATE    Date 04Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  CRP013 - Created for requirement to include delaying and     *
      *           retrying in the bulk download process.              *
      *                                                               *
      *****************************************************************
      /EJECT

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the prototypes for the procedures
      ** defined in this member.                                            s
     D/COPY RPCPYSRC,STR_PR
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


      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      * --------------------------------------------------------------------
      * This procedure returns a right-aligned string of length 10.
      * It is designed to be called from CL procedures, hence accepts its
      * parameter by reference.  RPG routines should use the
      * general-purpose rightAlign procedure.
     P rightAlignFixed10...
     P                 B                   export
     D rightAlignFixed10...
     D                 PI            10A
     D   inString                    10A

     C                   return    rightAlign(inString)

     P rightAlignFixed10...
     P                 E
      * --------------------------------------------------------------------

      * --------------------------------------------------------------------
      * This procedure returns a right-aligned string of any length up
      * to the maximum
     P rightAlign      B                   export
     D rightAlign      PI         32767A   varying
     D   inString                 32767A   varying value
     D   returnLength                10U 0 value options(*nopass)

     D returnString    S          32767A   varying
     D textLength      S             10U 0
     D firstChar       S             10U 0


      * Get length of received text
     C                   eval      textLength = %len(%trim(inString))

      * If the return length was requested, set the length of the
      * return field to that value; otherwise set it to the length of
      * the received string (the actual length of the varying string,
      * not the text within it).  However, if the requested length
      * is less than the text length, set the return length to the text
      * length; otherwise we might lose data, and this routine is not
      * intended to be used for concatenation.
     C                   if        %parms > 1 and
     C                             %addr(returnLength) <> *null and
     C                               returnLength >= textLength

     C                   eval      %len(returnString) = returnLength
     C                   else
     C                   eval      %len(returnString) = %len(inString)

     C                   endif

      * Get starting position of text in field
     C     ' '           check     inString      firstChar

      * If incoming field is blank (FirstChar = 0), end processing
     C                   if        firstChar > 0

     C                   EVAL      %subst(returnString :
     C                                %len(returnString) - textLength + 1) =
     C                             %subst(inString : firstChar : textLength)

     C                   endif

     C                   return    returnString

     P rightAlign      E
      * --------------------------------------------------------------------

