/*
* Licensed Materials - Property of IBM
* 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82 
* Copyright IBM Corp. 1987, 2018. All Rights Reserved.
*
* Note to U.S. Government Users Restricted Rights: 
* Use, duplication or disclosure restricted by GSA ADP Schedule 
* Contract with IBM Corp.
*/

package monitoringevents;

import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.sun.syndication.io.FeedException;

/**
 * Write the RSS
 */
public class EventsFeedServlet extends HttpServlet {
 
	private static final long serialVersionUID = 1L;
	private final static Logger logger = Logger.getLogger(EventsFeedServlet.class);

	public void doGet(HttpServletRequest req, HttpServletResponse resp) {
		try {
			if (req.getParameter("reset") != null) {
				try {
					Utils.rssHelper.reset();
				} catch (FeedException e) {
					logger.error(e);
				}
			}
			resp.setContentType("text/xml");
			ServletOutputStream os = resp.getOutputStream();
			try {
				os.print(Utils.rssHelper.get());
			} catch (FeedException e) {
				logger.error(e);
			}
			os.flush();
			os.close();
		} catch (IOException ioe) {
			logger.error(ioe);
		}
	}

}
